import React from 'react';
import {
  LayoutDashboard,
  Users,
  Building2,
  ShieldAlert,
  Scale,
  Briefcase,
  GraduationCap,
  Home,
  FileText,
  BadgeAlert,
  Smartphone
} from 'lucide-react';

export type PageId =
  | 'mobile-app'
  | 'dashboard'
  | 'users'
  | 'listings'
  | 'moderation'
  | 'disputes'
  | 'b2b-corporate'
  | 'b2b-colleges'
  | 'b2b-operators'
  | 'audit-logs';

interface SidebarProps {
  currentPage: PageId;
  onSelectPage: (page: PageId) => void;
  pendingModerationCount?: number;
  openDisputesCount?: number;
}

export const Sidebar: React.FC<SidebarProps> = ({
  currentPage,
  onSelectPage,
  pendingModerationCount = 2,
  openDisputesCount = 1
}) => {
  const adminNav = [
    { id: 'mobile-app' as PageId, label: '📱 Mobile App Demo', icon: Smartphone, badge: 'Live', badgeColor: 'bg-teal-500' },
    { id: 'dashboard' as PageId, label: 'Analytics & North Star', icon: LayoutDashboard },
    { id: 'users' as PageId, label: 'User Directory & KYC', icon: Users },
    { id: 'listings' as PageId, label: 'Listings & Quality', icon: Building2 },
    {
      id: 'moderation' as PageId,
      label: 'Moderation Queue',
      icon: ShieldAlert,
      badge: pendingModerationCount > 0 ? pendingModerationCount : undefined,
      badgeColor: 'bg-rose-500'
    },
    {
      id: 'disputes' as PageId,
      label: 'Dispute Desk',
      icon: Scale,
      badge: openDisputesCount > 0 ? openDisputesCount : undefined,
      badgeColor: 'bg-amber-500'
    },
    { id: 'audit-logs' as PageId, label: 'Security & Audit Logs', icon: FileText }
  ];

  const b2bNav = [
    { id: 'b2b-corporate' as PageId, label: 'Corporate Relocation', icon: Briefcase },
    { id: 'b2b-colleges' as PageId, label: 'College Housing', icon: GraduationCap },
    { id: 'b2b-operators' as PageId, label: 'PG & Co-Living Portals', icon: Home }
  ];

  return (
    <aside className="w-64 bg-slate-900 text-slate-300 flex flex-col shrink-0 min-h-screen border-r border-slate-800">
      {/* Brand Header */}
      <div className="h-16 px-6 flex items-center gap-3 border-b border-slate-800 bg-slate-950/40">
        <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-emerald-500 to-teal-400 flex items-center justify-center text-white shadow-lg shadow-emerald-500/20">
          <Home className="w-5 h-5" />
        </div>
        <div>
          <span className="text-lg font-bold text-white tracking-tight">FlatFit</span>
          <span className="ml-1.5 px-2 py-0.5 text-[10px] font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/30 rounded-full">
            Admin v2.4
          </span>
        </div>
      </div>

      {/* Navigation Sections */}
      <div className="flex-1 py-6 px-3 space-y-6 overflow-y-auto">
        <div>
          <div className="px-3 mb-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">
            Admin & Moderation
          </div>
          <nav className="space-y-1">
            {adminNav.map(item => {
              const Icon = item.icon;
              const isActive = currentPage === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => onSelectPage(item.id)}
                  className={`w-full flex items-center justify-between px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${
                    isActive
                      ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/20'
                      : 'text-slate-400 hover:text-slate-100 hover:bg-slate-800/60'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                    <span>{item.label}</span>
                  </div>
                  {item.badge !== undefined && (
                    <span
                      className={`px-1.5 py-0.5 text-xs font-semibold rounded-full text-white ${item.badgeColor || 'bg-slate-700'}`}
                    >
                      {item.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </div>

        <div>
          <div className="px-3 mb-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">
            B2B Enterprise Portals
          </div>
          <nav className="space-y-1">
            {b2bNav.map(item => {
              const Icon = item.icon;
              const isActive = currentPage === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => onSelectPage(item.id)}
                  className={`w-full flex items-center justify-between px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${
                    isActive
                      ? 'bg-emerald-600 text-white shadow-md shadow-emerald-600/20'
                      : 'text-slate-400 hover:text-slate-100 hover:bg-slate-800/60'
                  }`}
                >
                  <div className="flex items-center gap-3">
                    <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                    <span>{item.label}</span>
                  </div>
                </button>
              );
            })}
          </nav>
        </div>
      </div>

      {/* Footer Profile */}
      <div className="p-4 border-t border-slate-800 bg-slate-950/30 flex items-center gap-3">
        <div className="w-8 h-8 rounded-full bg-slate-700 flex items-center justify-center font-semibold text-slate-200 text-xs">
          NV
        </div>
        <div className="flex-1 min-w-0">
          <div className="text-xs font-medium text-slate-200 truncate">Neha Verma</div>
          <div className="text-[10px] text-emerald-400 font-mono">SuperAdmin (L3)</div>
        </div>
        <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" title="System Live" />
      </div>
    </aside>
  );
};
