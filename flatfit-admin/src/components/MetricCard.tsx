import React from 'react';
import { ArrowUpRight, ArrowDownRight, Minus, LucideIcon } from 'lucide-react';

interface MetricCardProps {
  label: string;
  value: string | number;
  change?: number;
  trend?: 'up' | 'down' | 'neutral';
  subtext?: string;
  icon?: LucideIcon;
  badge?: string;
}

export const MetricCard: React.FC<MetricCardProps> = ({
  label,
  value,
  change,
  trend = 'neutral',
  subtext,
  icon: Icon,
  badge
}) => {
  const isPositive = trend === 'up';
  const isNegative = trend === 'down';

  return (
    <div className="bg-white rounded-xl border border-slate-200/80 p-5 shadow-sm hover:shadow transition-shadow">
      <div className="flex items-center justify-between mb-2">
        <span className="text-xs font-semibold uppercase tracking-wider text-slate-500">
          {label}
        </span>
        {Icon && (
          <div className="w-8 h-8 rounded-lg bg-slate-50 flex items-center justify-center text-slate-600">
            <Icon className="w-4 h-4" />
          </div>
        )}
      </div>

      <div className="flex items-baseline gap-2 mb-2">
        <div className="text-2xl font-bold text-slate-900 tracking-tight">{value}</div>
        {change !== undefined && (
          <span
            className={`inline-flex items-center text-xs font-semibold px-1.5 py-0.5 rounded ${
              isPositive
                ? 'text-emerald-700 bg-emerald-50'
                : isNegative
                ? 'text-rose-700 bg-rose-50'
                : 'text-slate-600 bg-slate-100'
            }`}
          >
            {isPositive && <ArrowUpRight className="w-3 h-3 mr-0.5" />}
            {isNegative && <ArrowDownRight className="w-3 h-3 mr-0.5" />}
            {trend === 'neutral' && <Minus className="w-3 h-3 mr-0.5" />}
            {Math.abs(change)}%
          </span>
        )}
      </div>

      <div className="flex items-center justify-between text-xs text-slate-500">
        <span>{subtext}</span>
        {badge && (
          <span className="px-2 py-0.5 bg-slate-100 text-slate-700 font-medium rounded-full text-[10px]">
            {badge}
          </span>
        )}
      </div>
    </div>
  );
};
