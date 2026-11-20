import React from 'react';
import {
  Bell,
  Search,
  Database,
  CheckCircle2,
  AlertCircle,
  MapPin,
  RefreshCw
} from 'lucide-react';
import { isSupabaseConfigured } from '../config/supabase';

interface HeaderProps {
  title: string;
  subtitle?: string;
  onRefresh?: () => void;
  selectedCity?: string;
  onCityChange?: (city: string) => void;
}

export const Header: React.FC<HeaderProps> = ({
  title,
  subtitle,
  onRefresh,
  selectedCity = 'Mumbai',
  onCityChange
}) => {
  return (
    <header className="h-16 bg-white border-b border-slate-200 px-8 flex items-center justify-between sticky top-0 z-20">
      <div>
        <h1 className="text-xl font-bold text-slate-900 tracking-tight">{title}</h1>
        {subtitle && <p className="text-xs text-slate-500">{subtitle}</p>}
      </div>

      <div className="flex items-center gap-4">
        {/* City Filter */}
        <div className="flex items-center gap-2 bg-slate-100 hover:bg-slate-200/70 transition-colors px-3 py-1.5 rounded-lg text-xs font-medium text-slate-700">
          <MapPin className="w-3.5 h-3.5 text-slate-500" />
          <select
            value={selectedCity}
            onChange={e => onCityChange && onCityChange(e.target.value)}
            className="bg-transparent border-none outline-none cursor-pointer text-slate-800 font-semibold"
          >
            <option value="Mumbai">Mumbai (All Zones)</option>
            <option value="Bengaluru">Bengaluru</option>
            <option value="Pune">Pune</option>
            <option value="Delhi-NCR">Delhi-NCR</option>
          </select>
        </div>

        {/* Database Mode Status */}
        <div
          className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-medium ${
            isSupabaseConfigured
              ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
              : 'bg-indigo-50 text-indigo-700 border border-indigo-200'
          }`}
          title={
            isSupabaseConfigured
              ? 'Connected to live Supabase backend'
              : 'Using integrated mock store with simulated Supabase tables'
          }
        >
          <Database className="w-3.5 h-3.5" />
          <span>{isSupabaseConfigured ? 'Supabase Live' : 'Demo Mock Mode'}</span>
          {isSupabaseConfigured ? (
            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
          ) : (
            <span className="w-1.5 h-1.5 rounded-full bg-indigo-500" />
          )}
        </div>

        {/* Refresh Button */}
        {onRefresh && (
          <button
            onClick={onRefresh}
            className="p-2 rounded-lg text-slate-500 hover:text-slate-800 hover:bg-slate-100 transition-colors"
            title="Refresh Data"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
        )}

        {/* Notification Bell */}
        <button className="relative p-2 rounded-lg text-slate-500 hover:text-slate-800 hover:bg-slate-100 transition-colors">
          <Bell className="w-4 h-4" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-rose-500" />
        </button>
      </div>
    </header>
  );
};
