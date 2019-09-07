# Project Structure

This project has the same structure as a default `Rails 6.0` project. It follows the MVC principle, with Vue and additional frontend application features added. Looking down from project root:

- app: where all the main content files live
  - assets: stores images and css files
  - channels: for web socket implementation (?) not used.
  - controllers: where all the rails actions (CRUD) are defined.
  - datatables: where all the ajax datatables are defined.
  - decorators: helper functions for the view can be defined here. not used.
  - helpers: helper functions for controllers are defined here. Reuseable functions and those that does not operate on the database are usually defined here. If a new file / module is added, it has to be included in ApplicationController before being used.
  - javascript: where all the frontend js are defined.
    - packs: page specific js
    - src: application-wide js, loaded everytime
  - mailers: where all the automated emails are defined, like password resets
  - views: where all the html.erb (html with ruby embedded) are defined. Unless specifically specified
- bin: where the rails and webpack binaries are located. Should not be edited manually.
- config: Rails configuration.
  - environments: configuration specific to each environment
  - initializers: Will be ran every time the rails server starts
  - webpack: webpack specific configuration
- db: rails database configuration
  - migrate: store all the migrations from the beginning of time.
  - seeds.rb: Store code used to generate database entries
- docs: this documentation, a VuePress working directory
- test: all the test code
- vendor: manually downloaded 3rd party libraries
- Gemfile: all the gems (plugins) of the rails application
- package.json: all the node packages used. Not edited directly, but using yarn instead.