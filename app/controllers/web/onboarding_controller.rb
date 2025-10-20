module Web
  class OnboardingController < ApplicationController
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

      # Skip symptoms if Ally
      if session[:stage] == "Ally"
        session[:symptoms] = []
        redirect_to web_contents_path(stage: "Ally"), notice: "Welcome, ally! Here are some ways to support." and return
      end

      # Non-ally users
      session[:symptoms] = params[:symptoms] if params[:symptoms]

      case session[:stage]
      when "Perimenopause", "Menopause", "Post-menopause"
        redirect_to web_contents_path(stage: session[:stage]), notice: "Welcome! We’ve curated resources for you." and return
      when "Not sure"
        redirect_to web_contents_path(stage: "General"), notice: "Explore general guidance to help you discover your path." and return
      else
        redirect_to web_home_index_path, alert: "Something went wrong. Please try again."
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