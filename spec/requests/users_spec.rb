# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#process_excel' do
    context 'when file is not uploaded' do
      it 'should return error flash and redirect to import file path' do
        post '/users/process_excel', params: {}
        expect(response).to redirect_to(import_users_path)
        follow_redirect!
        expect(response.body).to include('Excel file not found, Please upload first.')
      end
    end

    context 'when file is uploaded' do
      context 'when file format is not excel' do
        it 'should handle and returns error message' do
          file = fixture_file_upload('invalid_excel.txt', 'text/plain')
          post '/users/process_excel', params: { user: { excel_file: file } }
          expect(response).to have_http_status(:success)
          expect(response.body).to include('Please upload a valid Excel file.')
        end
      end

      context 'when file format is excel' do
        context 'when all spreadsheets and records of excel processed successfully' do
          context 'when all records are valid formats' do
            it 'should returns success and create users records' do
              file = fixture_file_upload('valid_excel.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
              expect do
                post '/users/process_excel', params: { user: { excel_file: file } }
              end.to change(User, :count).by(8)
              expect(response).to have_http_status(:success)
              expect(response.body).to include('Total Counts: 8', 'Success Counts: 8', 'Failed Counts: 0')
            end
          end

          context 'when some of records are invalid formats' do
            it 'should returns success and create users records' do
              file = fixture_file_upload('valid_excel_with_some_invalid_record.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
              expect do
                post '/users/process_excel', params: { user: { excel_file: file } }
              end.to change(User, :count).by(4)
              expect(response).to have_http_status(:success)
              expect(response.body).to include('Total Counts: 8', 'Success Counts: 4', 'Failed Counts: 4', 'Failed rows result')
            end
          end
        end
      end
    end
  end
end
