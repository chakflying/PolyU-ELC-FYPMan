# frozen_string_literal: true

module SupervisorsHelper
  def get_sup_netID_suffix
    return "" if !logged_in?
    case current_user.department.university.code
    when "CUHK"
      "@cuhk.edu.hk"
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
