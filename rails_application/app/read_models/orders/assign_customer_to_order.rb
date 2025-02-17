module Orders
  class AssignCustomerToOrder < Infra::EventHandler
    def call(event)
      order_uid = event.data.fetch(:order_id)
      order = Order.find_by(uid: order_uid)

      if order.nil?
        order = Order.create!(uid: order_uid, state: "Draft")
      end

      order.customer = Customer.find_by_uid(event.data.fetch(:customer_id)).name
      order.save!

      event_store.link_event_to_stream(event, "Orders$all")
    end
  end
end
