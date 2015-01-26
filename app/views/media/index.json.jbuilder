json.array! params[:category_id] ? Medium.where(category_id: params[:category_id]) : @media do |medium|
    json.value medium.id
    json.text medium.name
end