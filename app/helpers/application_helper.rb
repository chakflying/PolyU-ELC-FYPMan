module ApplicationHelper
    def reset_hsts
        response.headers['Strict-Transport-Security'] = 'max-age=0; includeSubDomains'
    end
    
end
