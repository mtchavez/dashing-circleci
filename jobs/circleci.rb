require 'circleci'

module Constants
  STATUSES = %w[failed passed running started broken timedout no_tests fixed success canceled]
  FAILED, PASSED, RUNNING, STARTED, BROKEN, TIMEDOUT, NOTESTS, FIXED, SUCCESS, CANCELED = STATUSES
  FAILED_C   = 0.05
  BROKEN_C   = 0.05
  TIMEDOUT_C = 0.3
  NO_TESTS_C = 0.5
  CANCELED_C = 0.5
  RUNNING_C  = 1.0
  STARTED_C  = 1.0
  FIXED_C    = 1.0
  PASSED_C   = 1.0
  SUCCESS_C  = 1.0
end

def broken_or_no_builds
  {
    label: 'N/A',
    value: 'N/A',
    committer: '',
    state: 'broken'
  }
end

def get_climate(builds = [])
  return '|' if builds.empty?
  statuses = builds[0..10].map { |build| build['status'] if build['branch'] == 'master' }.compact
  weight = nil

  statuses.each do |status|
    factor = Constants.const_get("#{status.upcase}_C") rescue nil
    next unless factor
    weight = weight.nil? ? factor : weight * factor
  end

  case weight
  when 0.0..0.25  then '9'
  when 0.26..0.5  then '7'
  when 0.51..0.75 then '1'
  when 0.76..1.0  then 'v'
  else
    '|'
  end
end

def get_build_info(builds=[])
  return broken_or_no_builds if builds.empty?
  build = builds.detect { |b| b['branch'] ==  'master' }
  {
    label: "Build ##{build['build_num']}",
    value: build['subject'],
    committer: build['committer_name'],
    state: build['status'],
    climate: get_climate(builds)
  }
end

config_file = File.dirname(File.expand_path(__FILE__)) + '/../config/circleci.yml'
config = YAML::load(File.open(config_file))

SCHEDULER.every('1m', { first_in: '2s', allow_overlapping: false }) do
  CircleCi.configure { |c| c.token = config['token'] }
  config['projects'].to_a.each do |options|
    res = CircleCi::Project.recent_builds options['user'], options['repo']
    body = res.body.is_a?(Array) ? res.body : []
    build_info = get_build_info(res.body)
    send_event(options['css_id'], { items: [build_info] })
  end
end
