class OldDb < ActiveRecord::Base  
    # self.abstract_class = true
    establish_connection "production_old".to_sym

    def self.sync
        User.all.each do |record|
            print record
            # OldDb.create(:email => record.email)
        end
    end
  end  