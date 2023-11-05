# frozen_string_literal: true

require 'creek'

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def import
    @user = User.new
  end

  def process_excel
    excel_file = params.dig(:user, :excel_file)
    if excel_file.blank?
      flash[:error] = I18n.t('users.excel_file_not_found')
      redirect_to import_users_path and return
    end

    @success_count = 0
    @failed_count = 0
    @failed_rows = []

    if excel_file.present? && excel_file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      excel = Creek::Book.new(excel_file)
      excel.sheets.each do |sheet|
        sheet.simple_rows.each_with_index do |row, index|
          next if index.zero?

          user = User.new(first_name: row['A'], last_name: row['B'], email_id: row['C'])

          if user.save
            @success_count += 1
          else
            @failed_count += 1
            @failed_rows << { row: index + 1, errors: user.errors.full_messages.join(', ') }
          end
        end
      end
      flash[:success] = I18n.t('users.process_excel_successful')
    else
      flash[:error] = I18n.t('users.upload_valid_file')
    end
  end
end
