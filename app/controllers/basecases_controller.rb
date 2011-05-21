class BasecasesController < ApplicationController
 
    before_filter :authorized_admin, :only => [:show] 
    before_filter :authorized_group_member, :only => [:show]
    

  def show
     @basecase = Basecase.find(params[:id])
     # @basecase = Basecase.new if signed_in?
     @annuals = @basecase.annuals
     @annual = Annual.new if signed_in?   
     @borrowings = @basecase.borrowings
     @borrowing = Borrowing.new if signed_in?      
  end

  def create
      @group = Group.find(params[:group_id])    
      @basecase = @group.basecases.build(params[:basecase]) 
    if @basecase.save
      flash[:success] = "Basecase created!"
      redirect_to groups_path
    else
      render groups_path
    end
  end

  def destroy
    Basecase.find(params[:id]).destroy
    flash[:success] = "Basecase deleted"
    if current_user.name == 'mandeep3'     
        redirect_to groups_path
    else
        redirect_to group_path(current_user.group_id)
    end

  end

  private

      def authorized_admin
          @basecase = Basecase.find(params[:id])
          @group = @basecase.group
          redirect_to root_path unless current_user_admin(current_user, @group)
      end

      def authorized_group_member
          @basecase = Basecase.find(params[:id])
          @group = @basecase.group 
          redirect_to root_path unless (@group.id == current_user.group_id  || current_user.name == 'mandeep3')   
      end


end