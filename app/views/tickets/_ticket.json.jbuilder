json.extract! ticket, :id, :title, :description, :status, :chat_history, :user_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
