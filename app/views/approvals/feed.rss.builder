#encoding: UTF-8

xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title 'Pending Approvals'
    xml.author 'Release DB'
    xml.description 'Pending Approvals'
    xml.link 'http://www.releasedb.com'
    xml.language 'en'
    
    @pending_approvals.each do |pending_approval|
      xml.item do
        reified = pending_approval.reify
        if pending_approval.item_type == 'Product'
          xml.title "New Product: #{reified.name}"
        else
          xml.title "New Release: #{reified.product.name}"
        end
        
        xml.pubDate pending_approval.created_at.to_s(:rfc822)
        xml.link 'http://www.releasedb.com/admin'
        xml.guid pending_approval.id
        
        description = "There is a new pending #{pending_approval.item_type.downcase}."
        
        content = "<p>There is a new pending #{pending_approval.item_type.downcase}. </p>"
        reified.attributes.each do |name, value|
          content += "<p>#{name}: #{value} </p>"
        end
        
        #xml.description description
        xml.tag! 'content:encoded' do
          xml.cdata! content
        end
      end
    end
  end
end