json.array! @categories do |category|
    json.id category.id
    json.value category.id
    json.text category.name
end