import React, { useState, useEffect } from 'react';
import {
  Home,
  CheckCircle,
  XCircle,
  Building2,
  Users,
  Percent,
  Bed,
  Sparkles,
  ChevronRight,
  ShieldCheck,
  Compass
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { MetricCard } from '../components/MetricCard';
import { api } from '../services/api';
import { OperatorAccount, OperatorProperty, SmartBedAllocation } from '../types';

export const B2BOperators: React.FC = () => {
  const [operators, setOperators] = useState<OperatorAccount[]>([]);
  const [properties, setProperties] = useState<OperatorProperty[]>([]);
  const [allocations, setAllocations] = useState<SmartBedAllocation[]>([]);
  const [selectedAllocation, setSelectedAllocation] = useState<SmartBedAllocation | null>(null);
  const [selectedProperty, setSelectedProperty] = useState<OperatorProperty | null>(null);
  const [loading, setLoading] = useState(true);

  const loadData = async () => {
    setLoading(true);
    try {
      const data = await api.getOperatorAccounts();
      setOperators(data.operators);
      setProperties(data.properties);
      setAllocations(data.allocations);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const handleUpdateAllocation = async (id: string, status: SmartBedAllocation['status']) => {
    try {
      const updated = await api.updateBedAllocationStatus(id, status);
      setAllocations(prev => prev.map(a => (a.id === updated.id ? updated : a)));
      setSelectedAllocation(null);
    } catch (err) {
      alert('Error updating allocation: ' + err);
    }
  };

  const operatorColumns: Column<OperatorAccount>[] = [
    {
      key: 'name',
      header: 'Operator & Type',
      render: op => (
        <div>
          <div className="font-bold text-slate-900">{op.name}</div>
          <div className="text-xs text-slate-400 capitalize">
            {op.type.toUpperCase()} • {op.properties_count} Properties in {op.cities.join(', ')}
          </div>
        </div>
      )
    },
    {
      key: 'occupancy_rate',
      header: 'Portfolio Occupancy',
      render: op => (
        <div className="text-xs">
          <div className="font-bold text-emerald-700">{op.occupancy_rate}% Occupied</div>
          <div className="w-24 bg-slate-100 h-1.5 rounded-full mt-1 overflow-hidden">
            <div className="bg-emerald-500 h-full rounded-full" style={{ width: `${op.occupancy_rate}%` }} />
          </div>
        </div>
      )
    },
    {
      key: 'compatibility_allocation_enabled',
      header: 'Smart Roommate AI',
      render: op => (
        <span className="px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1 w-max">
          <Sparkles className="w-3 h-3 text-emerald-600" />
          Active Engine
        </span>
      )
    },
    {
      key: 'commission_pct',
      header: 'FlatFit Fee',
      render: op => (
        <div className="text-xs font-mono font-medium text-slate-800">
          {op.commission_pct}% Per Move-in
        </div>
      )
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: op => (
        <span className="text-xs text-slate-400 font-medium">
          Verified Enterprise Partner
        </span>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">
            PG & Co-Living Inventory & Compatibility Allocation
          </h2>
          <p className="text-xs text-slate-500">
            Intelligent roommate compatibility allocation for large-scale PG & co-living chains to reduce resident friction
          </p>
        </div>

        <span className="text-xs font-semibold px-3 py-1.5 rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-200 flex items-center gap-1">
          <Sparkles className="w-3.5 h-3.5" />
          Compatibility Bed Engine v2.0
        </span>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <MetricCard
          label="Managed Co-Living Beds"
          value="4,850 Beds"
          change={16.2}
          trend="up"
          subtext="Mumbai, Navi Mumbai & Thane"
          icon={Bed}
        />
        <MetricCard
          label="System Occupancy Yield"
          value="93.8%"
          change={4.1}
          trend="up"
          subtext="+8.4% higher than non-matched PGs"
          icon={Home}
        />
        <MetricCard
          label="Resident Churn / Room Changes"
          value="< 1.8%"
          change={-24.0}
          trend="up"
          subtext="Drastically reduced roommate conflicts"
          icon={Users}
        />
      </div>

      {/* Operators Table */}
      <DataTable
        columns={operatorColumns}
        data={operators}
        searchPlaceholder="Search co-living operators, cities..."
        pageSize={5}
      />

      {/* Smart Compatibility Bed Allocation Desk */}
      <section className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <div className="flex items-center gap-2">
              <Sparkles className="w-5 h-5 text-emerald-600" />
              <h3 className="text-base font-bold text-slate-900 tracking-tight">
                Pending Smart Bed Allocation Proposals
              </h3>
            </div>
            <p className="text-xs text-slate-500">
              AI recommendations matching applicant lifestyles with existing bed occupants
            </p>
          </div>
          <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-indigo-50 text-indigo-700">
            {allocations.length} Recommendations
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {allocations.map(alloc => (
            <div
              key={alloc.id}
              className="p-5 rounded-xl border border-slate-200 bg-slate-50/50 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between text-xs mb-2">
                  <span className="font-bold text-slate-900">{alloc.property_name}</span>
                  <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">
                    {alloc.compatibility_score}% Compatibility
                  </span>
                </div>

                <div className="text-xs font-medium text-slate-600 mb-3">
                  {alloc.room_number} • <strong className="text-slate-800">{alloc.bed_number}</strong>
                </div>

                {/* Candidate vs Resident Habit Comparison */}
                <div className="p-3 bg-white rounded-lg border border-slate-200 mb-3 space-y-2 text-xs">
                  <div className="flex items-start justify-between">
                    <span className="text-slate-400 font-semibold text-[10px] uppercase">Existing Resident</span>
                    <span className="font-semibold text-slate-800">{alloc.existing_resident_name}</span>
                  </div>
                  <div className="flex items-start justify-between border-t border-slate-100 pt-1.5">
                    <span className="text-slate-400 font-semibold text-[10px] uppercase">Candidate Applicant</span>
                    <span className="font-bold text-emerald-700">{alloc.recommended_candidate_name}</span>
                  </div>
                </div>

                <div className="space-y-1 mb-4">
                  <div className="text-[10px] font-bold uppercase tracking-wider text-slate-400">
                    Why This Bed Matches
                  </div>
                  {alloc.match_reasons.map((r, i) => (
                    <div key={i} className="text-xs text-slate-600 flex items-center gap-1.5">
                      <CheckCircle className="w-3.5 h-3.5 text-emerald-600 shrink-0" />
                      <span>{r}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="pt-3 border-t border-slate-200 flex items-center justify-between text-xs">
                <span className="capitalize font-semibold text-slate-600">
                  Status:{' '}
                  <strong className={alloc.status === 'allocated' ? 'text-emerald-700' : 'text-amber-700'}>
                    {alloc.status}
                  </strong>
                </span>

                <div className="flex items-center gap-2">
                  {alloc.status !== 'allocated' && (
                    <button
                      onClick={() => handleUpdateAllocation(alloc.id, 'allocated')}
                      className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white font-semibold rounded-lg shadow-sm"
                    >
                      Confirm Allocation
                    </button>
                  )}
                  {alloc.status !== 'rejected' && (
                    <button
                      onClick={() => handleUpdateAllocation(alloc.id, 'rejected')}
                      className="px-2.5 py-1.5 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-lg"
                    >
                      Decline
                    </button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};
