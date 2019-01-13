class AssignController < ApplicationController
    before_action :authenticate_user!

    def assign
        if is_admin?
            @students = Student.all.select(:netID, :name).to_a
            @supervisors = Supervisor.all.select(:netID, :name).to_a
        else
            @students = Student.where(department: current_user.department).select(:netID, :name).to_a
            @supervisors = Supervisor.where(department: current_user.department).select(:netID, :name).to_a
        end
        if request.post?
            stu_ids = request.params[:student_netID].values
            sup_id = (request.params[:supervisor_netID].values)[0].to_s
            sup = Supervisor.find_by(netID: sup_id)
            if !sup
                flash[:danger] = Array(flash[:danger]).push("Supervisor with netID " + sup_id + " not found.")
                render plain: "submitted"
                return
            end
            stu_ids.each do |stu_id|
                stu = Student.find_by(netID: stu_id)
                if !stu
                    flash[:danger] = Array(flash[:danger]).push("Student with netID " + stu_id + " not found.")
                elsif stu.supervisors.find_by(netID: sup_id)
                    flash[:info] = Array(flash[:info]).push("Student with netID " + stu_id + " already assigned.")
                else
                    stu.supervisors << sup
                    olddb_assign(stu.netID, sup.netID)
                    flash[:success] = Array(flash[:success]).push("Student with netID " + stu_id + " assigned successfully.")
                end
            end
            render plain: "submitted"
        end
    end
    
    def batch_assign
        if request.post?
            flash[:assign_lists] = request.params[:assign_lists]
            students_netID_list = request.params[:assign_lists][:students_list].lines.each {|x| x.strip!}
            supervisors_netID_list = request.params[:assign_lists][:supervisors_list].lines.each {|x| x.strip!}
            if students_netID_list.length != supervisors_netID_list.length
                flash.now[:danger] = Array(flash.now[:danger]).push("The length of two lists is not equal. Check if you need an extra line at the end.")
                render 'batch_assign'
                return
            end
            # Verify that all netIDs exist before actual operation
            students_netID_list.zip(supervisors_netID_list).each{ |stu_id,sup_id| 
                stu = Student.find_by(netID: stu_id)
                if !stu
                    flash.now[:danger] = Array(flash.now[:danger]).push("Student with netID " + stu_id + " not found.")
                    render 'batch_assign'
                    return
                end
                sup = Supervisor.find_by(netID: sup_id)
                if !sup
                    flash.now[:danger] = Array(flash.now[:danger]).push("Supervisor with netID " + sup_id + " not found.")
                    render 'batch_assign'
                    return
                end
            }
            students_netID_list.zip(supervisors_netID_list).each{ |stu_id,sup_id| 
                stu = Student.find_by(netID: stu_id)
                sup = Supervisor.find_by(netID: sup_id)
                if stu.supervisors.find_by(netID: sup_id)
                    flash[:info] = Array(flash[:info]).push("Student with netID " + stu_id + " already assigned.")
                else
                    stu.supervisors << sup
                    olddb_assign(stu.netID, sup.netID)
                end
            }

            flash[:success] = Array(flash[:success]).push("All students assigned successfully.")
            flash.delete(:assign_lists)
            redirect_to '/batch_assign'
        end
    end

    def olddb_assign(stu_netID, sup_netID)
        @old_student = OldUsers.first(net_id: stu_netID)
        @old_supervisor = OldUsers.first(net_id: sup_netID)
        @old_rel = OldRelations.create(student_net_id: @old_student.id, supervisor_net_id: @old_supervisor.id, status: 1)
    end
end