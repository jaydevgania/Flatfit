import React, { useState, useEffect } from 'react';
import {
  Briefcase,
  Users,
  Building,
  CheckCircle,
  Clock,
  Plus,
  Mail,
  TrendingUp,
  Award,
  Layers,
  ChevronRight
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { MetricCard } from '../components/MetricCard';
import { api } from '../services/api';
import { CorporateAccount, RelocationCohort, CorporateEmployee } from '../types';

export const B2BCorporate: React.FC = () => {
  const [accounts, setAccounts] = useState<CorporateAccount[]>([]);
  const [cohorts, setCohorts] = useState<RelocationCohort[]>([]);
  const [employees, setEmployees] = useState<CorporateEmployee[]>([]);
  const [selectedAccount, setSelectedAccount] = useState<CorporateAccount | null>(null);
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [newCompany, setNewCompany] = useState({
    company_name: '',
    contact_email: '',
    contact_phone: '',
    plan: 'enterprise' as const,
    domains: '',
    budget_stipend_monthly: 25000,
    max_employees: 500,
    is_active: true
  });
  const [loading, setLoading] = useState(true);

  const loadData = async () => {
    setLoading(true);
    try {
      const data = await api.getCorporateAccounts();
      setAccounts(data.accounts);
      setCohorts(data.cohorts);
      setEmployees(data.employees);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const handleCreateAccount = async () => {
    if (!newCompany.company_name || !newCompany.contact_email) {
      alert('Company name and contact email are required.');
      return;
    }
    try {
      const domainsArr = newCompany.domains
        .split(',')
        .map(d => d.trim().toLowerCase())
        .filter(Boolean);

      const created = await api.addCorporateAccount({
        company_name: newCompany.company_name,
        contact_email: newCompany.contact_email,
        contact_phone: newCompany.contact_phone,
        plan: newCompany.plan,
        max_employees: Number(newCompany.max_employees),
        employee_count: 0,
        domains: domainsArr.length ? domainsArr : ['company.com'],
        budget_stipend_monthly: Number(newCompany.budget_stipend_monthly),
        is_active: true
      });

      setAccounts(prev => [created, ...prev]);
      setIsAddModalOpen(false);
      setNewCompany({
        company_name: '',
        contact_email: '',
        contact_phone: '',
        plan: 'enterprise',
        domains: '',
        budget_stipend_monthly: 25000,
        max_employees: 500,
        is_active: true
      });
    } catch (err) {
      alert('Error creating corporate account: ' + err);
    }
  };

  const accountColumns: Column<CorporateAccount>[] = [
    {
      key: 'company_name',
      header: 'Company / Organization',
      render: acc => (
        <div>
          <div className="font-bold text-slate-900">{acc.company_name}</div>
          <div className="text-xs text-slate-400 font-mono">
            Domains: {acc.domains.join(', ')}
          </div>
        </div>
      )
    },
    {
      key: 'plan',
      header: 'Plan Tier',
      render: acc => (
        <span className="px-2.5 py-0.5 rounded-full text-xs font-bold uppercase bg-indigo-50 text-indigo-700 border border-indigo-200">
          {acc.plan}
        </span>
      )
    },
    {
      key: 'employees',
      header: 'Employees Placed',
      render: acc => {
        const pct = Math.round((acc.placed_employees / (acc.employee_count || 1)) * 100);
        return (
          <div className="text-xs">
            <div className="font-semibold text-slate-800">
              {acc.placed_employees} / {acc.employee_count}{' '}
              <span className="text-emerald-700 font-bold">({pct}%)</span>
            </div>
            <div className="w-24 bg-slate-100 h-1.5 rounded-full mt-1 overflow-hidden">
              <div
                className="bg-emerald-500 h-full rounded-full"
                style={{ width: `${Math.min(100, pct)}%` }}
              />
            </div>
          </div>
        );
      }
    },
    {
      key: 'compatibility',
      header: 'Internal Harmony',
      render: acc => (
        <span className="px-2.5 py-1 text-xs font-bold rounded-lg bg-emerald-50 text-emerald-700 border border-emerald-200">
          {acc.compatibility_index_avg}% Match
        </span>
      )
    },
    {
      key: 'subsidy',
      header: 'Monthly Stipend / User',
      render: acc => (
        <div className="text-xs font-mono font-medium text-slate-900">
          ₹{(acc.budget_stipend_monthly || 0).toLocaleString()}
        </div>
      )
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: acc => (
        <button
          onClick={() => setSelectedAccount(acc)}
          className="px-3 py-1 text-xs font-medium bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg flex items-center gap-1"
        >
          Cohorts & Roster <ChevronRight className="w-3 h-3" />
        </button>
      )
    }
  ];

  return (
    <div className="space-y-6">
      {/* Top Banner & Stats */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">
            Corporate Relocation & B2B Talent Housing
          </h2>
          <p className="text-xs text-slate-500">
            Automate roommate matching among coworkers, email domain auto-whitelisting, and company housing stipends
          </p>
        </div>

        <button
          onClick={() => setIsAddModalOpen(true)}
          className="px-4 py-2 text-xs font-semibold bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg flex items-center gap-1.5 shadow-sm"
        >
          <Plus className="w-4 h-4" />
          <span>Add Enterprise Client</span>
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <MetricCard
          label="Total Corporate Employees"
          value="1,710"
          change={21.4}
          trend="up"
          subtext="Across 42 active enterprise partners"
          icon={Users}
        />
        <MetricCard
          label="Avg Co-Worker Compatibility"
          value="95.1%"
          change={3.2}
          trend="up"
          subtext="Sleep, commute & lifestyle alignment"
          icon={Award}
        />
        <MetricCard
          label="Disbursed Relocation Subsidies"
          value="₹7.82 Cr"
          change={18.0}
          trend="up"
          subtext="Direct employer-to-escrow disbursements"
          icon={TrendingUp}
        />
      </div>

      {/* Corporate Accounts Table */}
      <DataTable
        columns={accountColumns}
        data={accounts}
        searchPlaceholder="Search enterprise clients, domains..."
        pageSize={6}
      />

      {/* Relocation Cohorts Active in Mumbai */}
      <section className="bg-white rounded-xl border border-slate-200 p-6 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-base font-bold text-slate-900 tracking-tight">
              Active Relocation Cohorts (Batch Housing)
            </h3>
            <p className="text-xs text-slate-500">
              Synchronized onboarding waves for lateral tech transfers & graduate joiners
            </p>
          </div>
          <span className="px-2.5 py-1 text-xs font-semibold bg-indigo-50 text-indigo-700 rounded-full border border-indigo-200">
            {cohorts.length} Active Waves
          </span>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {cohorts.map(c => {
            const pct = Math.round((c.placed_count / c.employee_count) * 100);
            return (
              <div key={c.id} className="p-4 rounded-xl border border-slate-200 bg-slate-50/50">
                <div className="flex items-center justify-between text-xs mb-1">
                  <span className="font-semibold text-slate-900 line-clamp-1">{c.cohort_name}</span>
                  <span className="capitalize px-2 py-0.5 rounded text-[10px] font-bold bg-emerald-100 text-emerald-800">
                    {c.status}
                  </span>
                </div>
                <div className="text-[11px] text-slate-500 mb-3">
                  Target: <strong className="text-slate-700">{c.target_city}</strong> • Starts:{' '}
                  {new Date(c.start_date).toLocaleDateString()}
                </div>

                <div className="flex items-center justify-between text-xs mb-1">
                  <span className="text-slate-600">Placement Progress</span>
                  <span className="font-bold text-slate-900">
                    {c.placed_count} / {c.employee_count} ({pct}%)
                  </span>
                </div>
                <div className="w-full bg-slate-200 h-2 rounded-full overflow-hidden">
                  <div
                    className="bg-emerald-500 h-full rounded-full transition-all"
                    style={{ width: `${pct}%` }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </section>

      {/* Account Details & Coworker Roster Modal */}
      {selectedAccount && (
        <Modal
          isOpen={Boolean(selectedAccount)}
          onClose={() => setSelectedAccount(null)}
          title={`${selectedAccount.company_name} — Relocation Dashboard`}
          subtitle={`Plan: ${selectedAccount.plan.toUpperCase()} • Whitelisted Domains: ${selectedAccount.domains.join(', ')}`}
          maxWidth="xl"
          footer={
            <button
              onClick={() => setSelectedAccount(null)}
              className="px-4 py-2 text-xs font-medium bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200"
            >
              Close
            </button>
          }
        >
          <div className="space-y-4">
            <div className="grid grid-cols-3 gap-3 p-3 bg-slate-50 rounded-xl text-xs">
              <div>
                <span className="text-slate-400 font-semibold text-[10px] uppercase">Enrolled</span>
                <div className="text-sm font-bold text-slate-900 mt-0.5">
                  {selectedAccount.employee_count} Employees
                </div>
              </div>
              <div>
                <span className="text-slate-400 font-semibold text-[10px] uppercase">Placed in Flats</span>
                <div className="text-sm font-bold text-emerald-700 mt-0.5">
                  {selectedAccount.placed_employees} Placed
                </div>
              </div>
              <div>
                <span className="text-slate-400 font-semibold text-[10px] uppercase">Monthly Stipend</span>
                <div className="text-sm font-bold text-slate-900 mt-0.5">
                  ₹{(selectedAccount.budget_stipend_monthly || 0).toLocaleString()}
                </div>
              </div>
            </div>

            <div>
              <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider mb-2">
                Employee Cohort Roster & Compatibility Matches
              </h4>
              <div className="divide-y divide-slate-100 border border-slate-200 rounded-xl overflow-hidden text-xs">
                {employees.map(emp => (
                  <div key={emp.id} className="p-3 bg-white hover:bg-slate-50 flex items-center justify-between">
                    <div>
                      <div className="font-semibold text-slate-900">{emp.name}</div>
                      <div className="text-[11px] text-slate-500">
                        {emp.designation} • {emp.department} ({emp.email})
                      </div>
                    </div>
                    <div className="text-right">
                      {emp.matched_coworker_name ? (
                        <div>
                          <div className="text-emerald-700 font-bold flex items-center gap-1 justify-end">
                            <span>Matched w/ {emp.matched_coworker_name}</span>
                          </div>
                          <span className="text-[10px] text-slate-400">
                            {emp.compatibility_score}% Compatibility • {emp.locality_assigned}
                          </span>
                        </div>
                      ) : (
                        <span className="px-2 py-0.5 rounded text-[10px] bg-amber-50 text-amber-700 font-semibold">
                          Matching in Progress
                        </span>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </Modal>
      )}

      {/* Add Enterprise Client Modal */}
      {isAddModalOpen && (
        <Modal
          isOpen={isAddModalOpen}
          onClose={() => setIsAddModalOpen(false)}
          title="Onboard Enterprise Corporate Client"
          maxWidth="md"
          footer={
            <>
              <button
                onClick={() => setIsAddModalOpen(false)}
                className="px-3 py-1.5 text-xs text-slate-600 hover:bg-slate-100 rounded-lg"
              >
                Cancel
              </button>
              <button
                onClick={handleCreateAccount}
                className="px-4 py-2 text-xs font-semibold text-white bg-emerald-600 hover:bg-emerald-700 rounded-lg"
              >
                Create Account
              </button>
            </>
          }
        >
          <div className="space-y-3 text-xs">
            <div>
              <label className="block font-semibold text-slate-700 mb-1">Company Name</label>
              <input
                type="text"
                value={newCompany.company_name}
                onChange={e => setNewCompany({ ...newCompany, company_name: e.target.value })}
                placeholder="e.g. Swiggy India / Flipkart"
                className="w-full p-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-emerald-500/20"
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="block font-semibold text-slate-700 mb-1">HR / Relocation Contact</label>
                <input
                  type="email"
                  value={newCompany.contact_email}
                  onChange={e => setNewCompany({ ...newCompany, contact_email: e.target.value })}
                  placeholder="relocations@swiggy.in"
                  className="w-full p-2 border border-slate-300 rounded-lg"
                />
              </div>
              <div>
                <label className="block font-semibold text-slate-700 mb-1">Contact Phone</label>
                <input
                  type="tel"
                  value={newCompany.contact_phone}
                  onChange={e => setNewCompany({ ...newCompany, contact_phone: e.target.value })}
                  placeholder="+91 98000 12345"
                  className="w-full p-2 border border-slate-300 rounded-lg"
                />
              </div>
            </div>
            <div>
              <label className="block font-semibold text-slate-700 mb-1">
                Whitelisted Email Domains (comma separated for auto-verification)
              </label>
              <input
                type="text"
                value={newCompany.domains}
                onChange={e => setNewCompany({ ...newCompany, domains: e.target.value })}
                placeholder="swiggy.in, swiggy.com"
                className="w-full p-2 border border-slate-300 rounded-lg font-mono text-xs"
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="block font-semibold text-slate-700 mb-1">Plan Tier</label>
                <select
                  value={newCompany.plan}
                  onChange={e => setNewCompany({ ...newCompany, plan: e.target.value as any })}
                  className="w-full p-2 border border-slate-300 rounded-lg"
                >
                  <option value="basic">Basic (Up to 100 employees)</option>
                  <option value="premium">Premium (Up to 500 employees)</option>
                  <option value="enterprise">Enterprise (Unlimited + Dedicated Escrow)</option>
                </select>
              </div>
              <div>
                <label className="block font-semibold text-slate-700 mb-1">Monthly Subsidy/User (₹)</label>
                <input
                  type="number"
                  value={newCompany.budget_stipend_monthly}
                  onChange={e => setNewCompany({ ...newCompany, budget_stipend_monthly: Number(e.target.value) })}
                  className="w-full p-2 border border-slate-300 rounded-lg"
                />
              </div>
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};
