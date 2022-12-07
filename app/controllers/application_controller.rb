# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, unless: :devise_controller?

  private
  
  def set_quote
    # We must use current_company.quotes here instead of Quote
    # for security reasons
    @quote = current_company.quotes.find(params[:id])
  end

  def current_company
    @current_company ||= current_user.company if user_signed_in?
  end
  helper_method :current_company
end
