# frozen_string_literal: true

module StudentsHelper
  # Return list of generated FYP Years [text, value] pairs.
  def get_fyp_years_list
    [
      [(Time.now.year - 1).to_s + '-' + Time.now.year.to_s, (Time.now.year - 1).to_s + '-' + Time.now.year.to_s],
      [Time.now.year.to_s + '-' + (Time.now.year + 1).to_s, Time.now.year.to_s + '-' + (Time.now.year + 1).to_s],
      [(Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s, (Time.now.year + 1).to_s + '-' + (Time.now.year + 2).to_s],
      [(Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s, (Time.now.year + 2).to_s + '-' + (Time.now.year + 3).to_s],
      [(Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s, (Time.now.year + 3).to_s + '-' + (Time.now.year + 4).to_s],
      [(Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s, (Time.now.year + 4).to_s + '-' + (Time.now.year + 5).to_s],
      [(Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s, (Time.now.year + 5).to_s + '-' + (Time.now.year + 6).to_s]
    ]
  end
  
  def get_stu_netID_suffix
    return "" if !logged_in?
    case current_user.department.university.code
    when "CUHK"
      "@link.cuhk.edu.hk"
    when "POLYU"
      "@polyu.edu.hk"
    when "CITYU"
      "@cityu.edu.hk"
    when "HKBU"
      "@hkbu.edu.hk"
    when "HKUST"
      "@ust.hk"
    else
      "@university"
    end
  end
end
