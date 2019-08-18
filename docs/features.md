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
