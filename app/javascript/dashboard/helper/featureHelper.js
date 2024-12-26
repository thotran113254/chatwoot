const FEATURE_HELP_URLS = {
  agent_bots: 'https://docs.mooly.vn/hc/agent-bots',
  agents: 'https://docs.mooly.vn/hc/agents',
  audit_logs: 'https://docs.mooly.vn/hc/audit-logs',
  campaigns: 'https://docs.mooly.vn/hc/campaigns',
  canned_responses: 'https://docs.mooly.vn/hc/canned',
  channel_email: 'https://docs.mooly.vn/hc/email',
  channel_facebook: 'https://docs.mooly.vn/hc/fb',
  custom_attributes: 'https://docs.mooly.vn/hc/custom-attributes',
  dashboard_apps: 'https://docs.mooly.vn/hc/dashboard-apps',
  help_center: 'https://docs.mooly.vn/hc/help-center',
  inboxes: 'https://docs.mooly.vn/hc/inboxes',
  integrations: 'https://docs.mooly.vn/hc/integrations',
  labels: 'https://docs.mooly.vn/hc/labels',
  macros: 'https://docs.mooly.vn/hc/macros',
  message_reply_to: 'https://docs.mooly.vn/hc/reply-to',
  reports: 'https://docs.mooly.vn/hc/reports',
  sla: 'https://docs.mooly.vn/hc/sla',
  team_management: 'https://docs.mooly.vn/hc/teams',
  webhook: 'https://docs.mooly.vn/hc/webhooks',
};

export function getHelpUrlForFeature(featureName) {
  return FEATURE_HELP_URLS[featureName];
}
