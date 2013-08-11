module Vito
  module Tests
    class VagrantTestBox
      BOXES_PATH = "spec/vagrant_boxes/"

      attr_reader :name

      def initialize(name)
        @name = name.to_s
      end

      def ssh_port
        grep_result = `grep "network :forwarded_port, guest: 22, host" #{vagrantfile_path}`
        grep_result.match(/host: ([0-9]{4})/)[1]
      end

      def path
        "#{BOXES_PATH}#{name}"
      end

      def initial_snapshot_name
        "#{name}_initial_box"
      end

      def self.boxes(*boxes)
        vagrant_boxes = []
        if boxes.size > 0
          vagrant_boxes = boxes
        else
          Dir["#{BOXES_PATH}*"].each do |box|
            vagrant_boxes << File.basename(box) if File.directory?(box)
          end
        end
        vagrant_boxes.map { |box| new(box) }
      end

      private

      def vagrantfile_path
        "#{path}/Vagrantfile"
      end
    end
  end
end
