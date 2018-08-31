module UsersHelper

  def gravatar_for(user, size: 100)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: "gravatar")
  end

  def is_admin?
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    else
      return false
    end
    return @current_user.admin
  end

  def set_last_seen_at
    current_user.update_column(:last_seen_at, Time.now)
  end

  def get_departments_list
    @departments_list = [
      ["Department of Applied Biology and Chemical Technology","Department of Applied Biology and Chemical Technology"],
      ["Department of Applied Mathematics","Department of Applied Mathematics"],
      ["Department of Applied Physics","Department of Applied Physics"],
      ["Institute of Textiles and Clothing","Institute of Textiles and Clothing"],
      ["School of Accounting and Finance","School of Accounting and Finance"],
      ["Department of Logistics and Maritime Studies","Department of Logistics and Maritime Studies"],
      ["Department of Management and Marketing","Department of Management and Marketing"],
      ["Department of Building and Real Estate","Department of Building and Real Estate"],
      ["Department of Building Services Engineering","Department of Building Services Engineering"],
      ["Department of Civil and Environmental Engineering","Department of Civil and Environmental Engineering"],
      ["Department of Land Surveying and Geo-Informatics","Department of Land Surveying and Geo-Informatics"],
      ["Department of Biomedical Engineering","Department of Biomedical Engineering"],
      ["Department of Computing","Department of Computing"],
      ["Department of Electrical Engineering","Department of Electrical Engineering"],
      ["Department of Electronic and Information Engineering","Department of Electronic and Information Engineering"],
      ["Department of Industrial and Systems Engineering","Department of Industrial and Systems Engineering"],
      ["Department of Mechanical Engineering","Department of Mechanical Engineering"],
      ["Interdisciplinary Division of Aeronautical and Aviation Engineering","Interdisciplinary Division of Aeronautical and Aviation Engineering"],
      ["Department of Applied Social Sciences","Department of Applied Social Sciences"],
      ["Department of Health Technology and Informatics","Department of Health Technology and Informatics"],
      ["Department of Rehabilitation Sciences","Department of Rehabilitation Sciences"],
      ["School of Nursing","School of Nursing"],
      ["School of Optometry","School of Optometry"],
      ["Department of Chinese and Bilingual Studies","Department of Chinese and Bilingual Studies"],
      ["Department of Chinese Culture","Department of Chinese Culture"],
      ["Department of English","Department of English"],
      ["Confucius Institute of Hong Kong","Confucius Institute of Hong Kong"],
      ["English Language Centre","English Language Centre"],
      ["General Education Centre","General Education Centre"],
      ["School of Design","School of Design"],
      ["School of Hotel and Tourism Management","School of Hotel and Tourism Management"]
    ]
  end
end