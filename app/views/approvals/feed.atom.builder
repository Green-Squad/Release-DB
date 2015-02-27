atom_feed do |feed|
  feed.title("Release DB Pending Approvals")
  feed.updated(@pending_approvals.first.created_at) if @pending_approvals.size > 0

  @pending_approvals.each do |pending_approval|
    feed.entry(pending_approval, url: 'http://www.releasedb.com/admin') do |entry|
      reified = pending_approval.reify
      
      if pending_approval.item_type == 'Product'
        entry.title "New Product: #{reified.name}"
      else
        entry.title "New Release: #{reified.product.name}"
      end
      
      content = "<p>There is a new pending #{pending_approval.item_type.downcase}. </p>"
      reified.attributes.each do |name, value|
        content += "<p>#{name}: #{value} </p>"
      end
      
      entry.content(content, type: 'html')
    end
  end
end
