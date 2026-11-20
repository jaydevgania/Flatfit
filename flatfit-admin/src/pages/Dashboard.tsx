import React, { useEffect, useState } from 'react';
import {
  TrendingUp,
  Users,
  CheckCircle,
  Clock,
  Home,
  Building,
  ArrowRight,
  ShieldCheck,
  Activity,
  Layers
} from 'lucide-react';
import { MetricCard } from '../components/MetricCard';
import { api } from '../services/api';
import { MetricStat, FunnelStage, RetentionCohort, LocalityMetric } from '../types';

export const Dashboard: React.FC = () => {
  const [metrics, setMetrics] = useState<MetricStat[]>([]);
  const [funnel, setFunnel] = useState<FunnelStage[]>([]);
  const [retention, setRetention] = useState<RetentionCohort[]>([]);
  const [localities, setLocalities] = useState<LocalityMetric[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadData() {
      try {
        const data = await api.getDashboardMetrics();
        setMetrics(data.northStar);
        setFunnel(data.funnel);
        setRetention(data.retention);
        setLocalities(data.localities);
      } catch (err) {
        console.error('Error loading dashboard data', err);
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  const getMetricIcon = (label: string) => {
    if (label.includes('Move-Ins')) return Home;
    if (label.includes('Match-to-Chat')) return Activity;
    if (label.includes('Harmony')) return ShieldCheck;
    if (label.includes('Time to Roommate')) return Clock;
    if (label.includes('Active Listings')) return Building;
    return Layers;
  };

  return (
    <div className="space-y-8 animate-in fade-in duration-200">
      {/* North-Star Metric Cards Grid */}
      <section>
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="text-lg font-bold text-slate-900 tracking-tight">Platform North-Star Metrics</h2>
            <p className="text-xs text-slate-500">Core health indicators for roommate placement & community retention</p>
          </div>
          <span className="text-xs font-medium text-emerald-700 bg-emerald-50 border border-emerald-200 px-2.5 py-1 rounded-full flex items-center gap-1.5">
            <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
            Live Cohort Telemetry
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {metrics.map((m, idx) => (
            <MetricCard
              key={idx}
              label={m.label}
              value={m.value}
              change={m.change}
              trend={m.trend}
              subtext={m.subtext}
              icon={getMetricIcon(m.label)}
            />
          ))}
        </div>
      </section>

      {/* Funnel Analytics: Match -> Chat -> Meet -> Movein */}
      <section className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 mb-6">
          <div>
            <div className="flex items-center gap-2">
              <TrendingUp className="w-5 h-5 text-emerald-600" />
              <h2 className="text-lg font-bold text-slate-900 tracking-tight">
                End-to-End Compatibility Funnel
              </h2>
            </div>
            <p className="text-xs text-slate-500 mt-0.5">
              Funnel progression from sign-up through questionnaire, compatibility opening, meet, and move-in agreement
            </p>
          </div>
          <div className="text-xs bg-slate-100 text-slate-700 font-semibold px-3 py-1 rounded-lg">
            Cumulative Conversion: <strong className="text-emerald-600">6.72%</strong>
          </div>
        </div>

        {/* Funnel Progress Bars */}
        <div className="space-y-4">
          {funnel.map((stage, idx) => {
            const maxCount = funnel[0]?.count || 1;
            const widthPct = Math.max(12, Math.round((stage.count / maxCount) * 100));
            return (
              <div key={idx} className="space-y-1.5">
                <div className="flex items-center justify-between text-xs">
                  <div className="flex items-center gap-2 font-medium text-slate-800">
                    <span className="w-5 h-5 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center text-[10px] font-bold">
                      {idx + 1}
                    </span>
                    <span>{stage.stage}</span>
                  </div>
                  <div className="flex items-center gap-4 text-slate-500">
                    <span>
                      <strong className="text-slate-800">{stage.count.toLocaleString()}</strong> users
                    </span>
                    <span className="text-emerald-700 font-semibold">
                      {stage.conversionRate}% conversion
                    </span>
                    {stage.dropOffRate > 0 && (
                      <span className="text-rose-600">
                        (-{stage.dropOffRate}% drop)
                      </span>
                    )}
                    <span className="text-slate-400 font-mono text-[11px]">
                      ~{stage.avgDurationDays}d
                    </span>
                  </div>
                </div>

                <div className="w-full bg-slate-100 h-3 rounded-full overflow-hidden flex">
                  <div
                    className="h-full bg-gradient-to-r from-emerald-500 to-teal-500 rounded-full transition-all duration-500 shadow-sm"
                    style={{ width: `${widthPct}%` }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* Cohort Retention & Living Harmony Table */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <section className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-base font-bold text-slate-900 tracking-tight">
                Cohorts 30 / 90 Day Living Harmony
              </h2>
              <p className="text-xs text-slate-500">
                Retention and post-movein harmony rating without disputes
              </p>
            </div>
            <ShieldCheck className="w-5 h-5 text-emerald-600" />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-50 text-slate-500 uppercase tracking-wider font-semibold border-b border-slate-200">
                <tr>
                  <th className="py-2.5 px-3">Cohort</th>
                  <th className="py-2.5 px-3">Placed</th>
                  <th className="py-2.5 px-3">30-Day Active</th>
                  <th className="py-2.5 px-3">90-Day Active</th>
                  <th className="py-2.5 px-3">Harmony</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {retention.map((c, i) => (
                  <tr key={i} className="hover:bg-slate-50/50">
                    <td className="py-2.5 px-3 font-semibold text-slate-800">{c.cohort}</td>
                    <td className="py-2.5 px-3 text-slate-600">{c.initialUsers}</td>
                    <td className="py-2.5 px-3">
                      <span className="font-semibold text-emerald-700">{c.day30Pct}%</span>{' '}
                      <span className="text-slate-400">({c.day30Active})</span>
                    </td>
                    <td className="py-2.5 px-3">
                      <span className="font-semibold text-emerald-700">{c.day90Pct}%</span>{' '}
                      <span className="text-slate-400">({c.day90Active})</span>
                    </td>
                    <td className="py-2.5 px-3">
                      <span className="inline-flex items-center px-2 py-0.5 rounded-full font-bold text-[11px] bg-emerald-50 text-emerald-700 border border-emerald-200">
                        {c.harmonyScoreAvg}/100
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        {/* Micro-Market City Demand Breakdown */}
        <section className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h2 className="text-base font-bold text-slate-900 tracking-tight">
                Mumbai Locality Breakdown
              </h2>
              <p className="text-xs text-slate-500">
                Liquidity, match rates, and average room rents by locality
              </p>
            </div>
            <Home className="w-5 h-5 text-indigo-600" />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-50 text-slate-500 uppercase tracking-wider font-semibold border-b border-slate-200">
                <tr>
                  <th className="py-2.5 px-3">Locality</th>
                  <th className="py-2.5 px-3">Users</th>
                  <th className="py-2.5 px-3">Listings</th>
                  <th className="py-2.5 px-3">Match %</th>
                  <th className="py-2.5 px-3">Avg Rent</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {localities.map((loc, i) => (
                  <tr key={i} className="hover:bg-slate-50/50">
                    <td className="py-2.5 px-3 font-semibold text-slate-800">{loc.locality}</td>
                    <td className="py-2.5 px-3 text-slate-600">{loc.activeUsers}</td>
                    <td className="py-2.5 px-3 text-slate-600">{loc.activeListings}</td>
                    <td className="py-2.5 px-3 font-semibold text-emerald-700">{loc.matchRate}%</td>
                    <td className="py-2.5 px-3 font-mono font-medium text-slate-800">
                      ₹{loc.avgRent.toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  );
};
