# Specific Features

## Using Ajax Datatables

### Creating a new Ajax Datatable

- Run `rails generate datatable *ModelName*`
- Open the generated file, edit `view_columns` to define searchable columns, edit `data` to define how to process each row from a database query to display each row in the table, and edit `get_raw_records` to define how the model is queried. You can also add custom methods to help with data processing.
- in `manage_tables.js`, you can use a custom classname to identify the table to display, and initialize it in the webpage. Parameters like column width and Responsive behaviour is also defined here.
- In the relevant controller, define your action to output json which renders the Datatable class. Information about the current user is also passed here as options to the class.
```ruby
def index
  ...
  respond_to do |format|
      format.html
      format.json { render json: SupervisorDatatable.new(params, admin: is_admin?, ...) }
    end
end
```
- In current implementation, some of the html code is mixed in with the datatables model file for ease of data processing. This is a bad design pattern.

## Database Sync

Database Sync between the `directus` database and the rails one is primarily achieved with a `sync_id` column in each of the tables, tracking the corresponding entry in the other database. Some of the entries with a unique identifer (e.g. `netID`) also checks for both timestamps to update on the latest information. The database schema for `directus` is defined in `old_db_init.rb`, and the sync code is located in `old_db.rb`.

### Sync Implementation

Rails uses Active Record for its default database ORM handling. When the project started, `rails 5.2` did not have full support for multiple database connection, and `directus` uses different names for timestamp entries which is not compatible with Active Record. Therefore, additional gem `Sequel` is used to connect to `directus`. Sequel has most of the same features of finding and updating records, but uses slightly different syntax. For example, in Active Record we find rows by
```ruby
Student.find(23)
Student.find_by(netID: test01@example.com)
```
but in Sequel the bracket syntax is used instead.
```ruby
OldUser[23]
OldUser[net_id: test01@example.com]
```
The Sequel ORM is used to manage the `directus` tables, while Active Record manages the Rails database tables.

Basic custom error logging is also implemented. Most of the common error locations have error checks and will store the error text and increment an error counter. At the end of sync, the counter and error messages will be stored in a database entry, in the model `SyncRecords`. Statistics about the runtime is also stored to track performance.

![Sync Records Page](./Screenshot_2019-08-26SyncRecordsPage.png)

### Sync Process

The process of Sync can be roughly divided into 3 steps: 
- Delete Synced records which are deleted in the `directus` database
- Update the Rails database base on each entry in the `directus` database
- Add new records in the `directus` database for unsynced entries

```ruby
      University.where.not(sync_id: nil).where.not(sync_id: OldUniversity.where(status: 1).pluck(:id)).each(&:destroy)
```
This line picks out the synced entries in our database, and deletes them if the corresponding entry in the `directus` database is missing/removed.

For Students, there is additional check of updating FYP Year if missing. Since Students and Supervisors are put in the same table in `directus`, additional check of `entry.role == '1'` is performed. The fact that role is a string type and not an integer type caused a lot of headaches.

For specific models like `supervises` and `chat_rooms_members`, it is impractical to track them by ID, since they are not meaningful in a per-record basis. Hence they are simply synced by copying the data from `directus`. After finding that the specified student and/or supervisor exists in our database, the relation will be created, and ignored otherwise.

Currently, this implementation requires loading students/supervisors repeatedly, causing slower performance during groups sync. Caching methods should be investigated to improve performance.

```ruby
OldChatRoomMember.all.each do |old_group_member|
        next if old_group_member.status != 1
        group = Group.find_by(sync_id: old_group_member.chat_room_id)
        student = Student.find_by(sync_id: old_group_member.user_id)
        supervisor = Supervisor.find_by(sync_id: old_group_member.user_id)
        ...
```

### Sync Trigger

Sync is scheduled by `Delay_job` and its extension `Delayed::RecurringJob`, defined in the bottom of `old_db_init.rb`. The block of code schedules the Sync task according to the time interval defined. Once defined, a separate process need to be started to actually run the task.

```ruby
class OldDbSyncTask
  include Delayed::RecurringJob
  run_every 2.minute
  queue 'slow_jobs'
  def perform
    OldDb.sync
  end
end
```