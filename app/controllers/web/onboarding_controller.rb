module Web
  class OnboardingController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :initialize_onboarding

    def step1; end

    def step2
      # Store from step1 (if anything)
      session[:stage] = params[:stage] if params[:stage]
      @selected_stage = session[:stage]
    end

    def step3
      session[:stage] = params[:stage] if params[:stage]

      if session[:stage] == "Ally"
        session[:symptoms] = [] # Clear any previously selected symptoms
        redirect_to web_onboarding_step4_path and return
      end

      session[:symptoms] = params[:symptoms] if params[:symptoms]
      @selected_symptoms = session[:symptoms]
    end


    def step4
      session[:symptoms] = params[:symptoms] if params[:symptoms] # carry over from step3
      @selected_country = session[:country]
    end

    def step5
      session[:country] = params[:country] if params[:country] # capture from step4

      @summary = {
        stage: session[:stage],
        symptoms: session[:symptoms],
        country: session[:country]
      }
    end

    def submit
      session[:stage] = params[:stage] if params[:stage]
      session[:country] = params[:country] if params[:country]

      if session[:stage] == "Ally"
        session[:symptoms] = []
      else
        session[:symptoms] = params[:symptoms] if params[:symptoms]
      end

      if user_signed_in?
        profile = current_user.user_profile || current_user.build_user_profile
        profile.update(
          stage: session[:stage],
          symptoms: session[:symptoms] || [],
          country: session[:country],
          locale: I18n.locale.to_s
        )
        redirect_to dashboard_path, notice: "Welcome! Your personalized dashboard is ready."
      else
        # Store return path for after signup
        session[:return_to] = dashboard_path
        redirect_to new_user_registration_path, notice: "Create an account to save your personalized experience!"
      end
    end

    private

    def initialize_onboarding
      session[:stage] ||= nil
      session[:symptoms] ||= []
      session[:country] ||= nil
    end
  end
end
