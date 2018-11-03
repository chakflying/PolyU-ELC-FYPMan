class OldDb < ActiveRecord::Base  
    # self.abstract_class = true
    establish_connection "production_old"

    def self.sync
        OldDb.all.each do |record|
            print record
            # OldDb.create(:email => record.email)
        end
    end
  end  