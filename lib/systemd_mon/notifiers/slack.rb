require 'systemd_mon/error'
require 'systemd_mon/notifiers/base'

begin
  require 'slack-notifier'
rescue LoadError
  raise SystemdMon::NotifierDependencyError, "The 'slack-notifier' gem (> 1.0) is required by the slack notifier"
end

module SystemdMon::Notifiers
  class Slack < Base
    def initialize(*)
      super
      self.notifier = ::Slack::Notifier.new(
        options.fetch('webhook_url'),
        channel: options['channel'],
        username: options['username'],
        icon_emoji: options['icon_emoji'],
        icon_url: options['icon_url'])
    end

    def notify_start!(hostname)
      message = "@channel SystemdMon is starting on #{hostname}"

      attach = {
        fallback: message,
        text: message,
        color: "good"
      }

      notifier.ping "", attachments: [attach]
    end

    def notify_stop!(hostname)
      message = "@channel SystemdMon is stopping on #{hostname}"

      attach = {
        fallback: message,
        text: message,
        color: "danger"
      }

      notifier.ping "", attachments: [attach]
    end

    def notify!(notification)
      unit = notification.unit
      message = "@channel #{notification.type_text}: systemd unit #{unit.name} on #{notification.hostname} #{unit.state_change.status_text}"

      return if notification.type == :info

      # if notification.type == :info
      #   message = "#{notification.type_text}: systemd unit #{unit.name} on #{notification.hostname} #{unit.state_change.status_text}"
      # end

      attach = {
        fallback: "@channel #{message}: #{unit.state.active} (#{unit.state.sub})",
        color: color(notification.type),
        fields: fields(notification)
      }

      debug("sending slack message with attachment: ")
      debug(attach.inspect)

      notifier.ping message, attachments: [attach]
      log "sent slack notification"
    end

  protected
    attr_accessor :notifier

    def fields(notification)
      f = [
        {
          title: "Hostname",
          value: notification.hostname,
          short: true
        },
        {
          title: "Unit",
          value: notification.unit.name,
          short: true
        }
      ]

      changes = notification.unit.state_change.diff.map(&:last)
      f.concat(changes.map { |v|
        { title: v.display_name, value: v.value, short: true }
      })
    end

    def color(type)
      case type
      when :alert
        'danger'
      when :warning
        '#FF9900'
      when :info
        '#0099CC'
      else
        'good'
      end
    end
  end
end
