module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:set_like, :set_dislike, :cancel_vote]
  end

  def set_like
    res = @resource.set_like!(current_user)
    render_respond(res)
  end

  def set_dislike
    res = @resource.set_dislike!(current_user)
    render_respond(res)
  end

  def cancel_vote
    res = @resource.cancel_vote!(current_user)
    render_respond(res)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_resource
    @resource = model_klass.find(params[:id])
  end

  def render_respond(result)
    return head(:forbidden) unless result
    respond_to do |format|
      format.json { render json: { id: @resource.id, rating: @resource.rating } }
    end
  end
end
