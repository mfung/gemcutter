class Rubygem < ActiveRecord::Base
  belongs_to :user
  has_many :versions
  has_many :dependencies

  attr_accessor :data, :spec
  before_validation :parse

  protected
    def parse
      self.spec = Gem::Format.from_file_by_path(self.data.path).spec
      self.name = spec.name

      cache = Gemcutter.server_path('gems', "#{spec.original_name}.gem")
      FileUtils.cp self.data.path, cache
      File.chmod 0644, cache

      version = self.versions.build(
        :authors     => spec.authors,
        :description => spec.description,
        :number      => spec.version)
    end
end