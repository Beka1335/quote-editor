# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, unless: :devise_controller?

  def create
    @quote = current_company.quotes.build(quote_params)

    if @quote.save
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: "Quote was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @quote.update(quote_params)
      redirect_to quotes_path, notice: "Quote was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy

    respond_to do |format|
      format.html { redirect_to quotes_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream
    end
  end

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
