class TaskSerializer < ActiveModel::Serializer
  attributes %i[
    name
    description
    priority
    category
  ]

  def id
    object.uuid
  end
end
