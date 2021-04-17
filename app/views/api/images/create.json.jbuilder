json.images do
  json.array! @results[:success] do |image|
    json.partial! 'api/images/image', { image: image }
  end
end
json.errors do
  json.array! @results[:errors] do |error|
    json.error error
  end
end
