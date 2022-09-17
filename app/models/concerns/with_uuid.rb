module WithUuid
  extend ActiveSupport::Concern

  included do
    after_initialize :prefill_uuid
  end

  def prefill_uuid
    self.uuid ||= SecureRandom.uuid if new_record? && !send('uuid')
  end
end
