module ApplicationHelper
    def reset_hsts
        response.set_header('Strict-Transport-Security', 'max-age=0; includeSubdomains;')
    end
    
end
