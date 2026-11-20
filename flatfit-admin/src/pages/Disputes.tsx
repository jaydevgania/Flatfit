import React, { useState, useEffect } from 'react';
import {
  Scale,
  AlertCircle,
  CheckCircle2,
  Clock,
  ArrowRight,
  FileText,
  DollarSign,
  User,
  ExternalLink,
  ShieldCheck
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { api } from '../services/api';
import { Dispute } from '../types';

export const Disputes: React.FC = () => {
  const [disputes, setDisputes] = useState<Dispute[]>([]);
  const [selectedDispute, setSelectedDispute] = useState<Dispute | null>(null);
  const [resolutionText, setResolutionText] = useState('');
  const [resolutionStatus, setResolutionStatus] = useState<Dispute['status']>('resolved');
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [filterType, setFilterType] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  const loadDisputes = async () => {
    setLoading(true);
    try {
      const data = await api.getDisputes();
      setDisputes(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDisputes();
  }, []);

  const handleResolve = async () => {
    if (!selectedDispute || !resolutionText.trim()) {
      alert('Please enter a resolution summary.');
      return;
    }
    try {
      const updated = await api.resolveDispute(selectedDispute.id, resolutionText, resolutionStatus);
      setDisputes(prev => prev.map(d => (d.id === updated.id ? updated : d)));
      setSelectedDispute(null);
      setResolutionText('');
    } catch (err) {
      alert('Error saving dispute resolution: ' + err);
    }
  };

  const filteredDisputes = disputes.filter(d => {
    if (filterStatus !== 'all' && d.status !== filterStatus) return false;
    if (filterType !== 'all' && d.type !== filterType) return false;
    return true;
  });

  const columns: Column<Dispute>[] = [
    {
      key: 'id',
      header: 'Dispute Docket',
      render: d => (
        <div>
          <div className="font-bold text-slate-900 font-mono text-xs">{d.id}</div>
          <div className="text-[11px] text-slate-400 capitalize">
            {d.type.replace('_', ' ')} Dispute
          </div>
        </div>
      )
    },
    {
      key: 'parties',
      header: 'Parties Involved',
      render: d => (
        <div className="text-xs">
          <div className="flex items-center gap-1.5 font-semibold text-slate-900">
            <User className="w-3.5 h-3.5 text-indigo-500" />
            <span>{d.raised_by_name}</span>
            <span className="text-slate-400 font-normal">v/s</span>
            <span>{d.against_name}</span>
          </div>
          <div className="text-slate-400 mt-0.5">Flat ID: {d.flat_id || 'Direct Agreement'}</div>
        </div>
      )
    },
    {
      key: 'amount_disputed',
      header: 'Claim Amount',
      render: d => (
        <div className="text-xs font-bold text-slate-900 font-mono">
          {d.amount_disputed ? `₹${d.amount_disputed.toLocaleString()}` : 'Non-Monetary'}
        </div>
      )
    },
    {
      key: 'status',
      header: 'Status',
      render: d => {
        const badge = {
          open: 'bg-rose-50 text-rose-700 border-rose-200',
          in_progress: 'bg-amber-50 text-amber-700 border-amber-200',
          resolved: 'bg-emerald-50 text-emerald-700 border-emerald-200',
          escalated: 'bg-purple-50 text-purple-700 border-purple-200'
        }[d.status];

        return (
          <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold border capitalize ${badge}`}>
            {d.status.replace('_', ' ')}
          </span>
        );
      }
    },
    {
      key: 'created_at',
      header: 'Filed On',
      render: d => (
        <div className="text-xs text-slate-500">
          {new Date(d.created_at).toLocaleDateString()}
        </div>
      )
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: d => (
        <button
          onClick={() => {
            setSelectedDispute(d);
            setResolutionText(d.resolution || '');
            setResolutionStatus(d.status === 'open' ? 'in_progress' : d.status);
          }}
          className="px-3 py-1 text-xs font-medium bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg"
        >
          Arbitrate
        </button>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">
            Security Deposit & Roommate Dispute Desk
          </h2>
          <p className="text-xs text-slate-500">
            Mediate deposit withholding, sudden move-outs without 30-day notice, and property damage settlements
          </p>
        </div>

        <div className="flex items-center gap-3">
          <select
            value={filterStatus}
            onChange={e => setFilterStatus(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Statuses</option>
            <option value="open">Open Claims</option>
            <option value="in_progress">In Mediation</option>
            <option value="resolved">Resolved</option>
          </select>

          <select
            value={filterType}
            onChange={e => setFilterType(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Dispute Categories</option>
            <option value="deposit">Deposit Withholding</option>
            <option value="notice_period">Notice Period Breach</option>
            <option value="damage">Property Damage</option>
            <option value="harassment">Conduct / Harassment</option>
          </select>
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredDisputes}
        searchPlaceholder="Search disputes by user names, ID, or description..."
        pageSize={8}
      />

      {/* Arbitration Modal */}
      {selectedDispute && (
        <Modal
          isOpen={Boolean(selectedDispute)}
          onClose={() => setSelectedDispute(null)}
          title={`Arbitration Case #${selectedDispute.id}`}
          subtitle={`Filed: ${new Date(selectedDispute.created_at).toLocaleString()}`}
          maxWidth="lg"
          footer={
            <div className="flex items-center gap-2">
              <button
                onClick={() => setSelectedDispute(null)}
                className="px-3 py-1.5 text-xs text-slate-600 hover:bg-slate-100 rounded-lg"
              >
                Close
              </button>
              <button
                onClick={handleResolve}
                className="px-4 py-2 text-xs font-semibold bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
              >
                Save Official Resolution & Order
              </button>
            </div>
          }
        >
          <div className="space-y-4">
            <div className="p-4 bg-slate-50 rounded-xl border border-slate-200">
              <div className="flex items-center justify-between text-xs mb-2">
                <span className="font-semibold text-slate-500 uppercase tracking-wider text-[10px]">
                  Claimant vs Respondent
                </span>
                <span className="font-mono text-sm font-bold text-rose-700">
                  {selectedDispute.amount_disputed
                    ? `Claim: ₹${selectedDispute.amount_disputed.toLocaleString()}`
                    : 'Non-Monetary'}
                </span>
              </div>
              <div className="flex items-center gap-3 text-sm font-semibold text-slate-900">
                <span className="px-2 py-0.5 bg-indigo-50 text-indigo-700 rounded border border-indigo-200">
                  {selectedDispute.raised_by_name}
                </span>
                <ArrowRight className="w-4 h-4 text-slate-400" />
                <span className="px-2 py-0.5 bg-slate-100 text-slate-800 rounded border border-slate-200">
                  {selectedDispute.against_name}
                </span>
              </div>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-1">
                Factual Narrative
              </div>
              <p className="text-xs text-slate-700 bg-slate-50 p-3 rounded-lg leading-relaxed border border-slate-200">
                {selectedDispute.description}
              </p>
            </div>

            {selectedDispute.evidence_urls && selectedDispute.evidence_urls.length > 0 && (
              <div>
                <div className="text-xs font-semibold uppercase text-slate-400 mb-1.5">
                  Attached Evidence (Agreements, Receipts, Chats)
                </div>
                <div className="space-y-1.5">
                  {selectedDispute.evidence_urls.map((url, i) => (
                    <div
                      key={i}
                      className="flex items-center justify-between p-2 rounded-lg bg-slate-50 border border-slate-200 text-xs"
                    >
                      <div className="flex items-center gap-2 text-slate-700 font-mono truncate max-w-sm">
                        <FileText className="w-4 h-4 text-slate-400 shrink-0" />
                        <span className="truncate">{url}</span>
                      </div>
                      <a
                        href={url}
                        target="_blank"
                        rel="noreferrer"
                        className="text-indigo-600 hover:text-indigo-800 text-[11px] font-semibold flex items-center gap-1 shrink-0"
                      >
                        Inspect <ExternalLink className="w-3 h-3" />
                      </a>
                    </div>
                  ))}
                </div>
              </div>
            )}

            <div className="pt-2 border-t border-slate-200">
              <div className="flex items-center justify-between mb-2">
                <label className="text-xs font-semibold text-slate-800">
                  Official Administrative Ruling / Mediation Settlement:
                </label>
                <div className="flex items-center gap-2">
                  <span className="text-xs text-slate-500">Status:</span>
                  <select
                    value={resolutionStatus}
                    onChange={e => setResolutionStatus(e.target.value as any)}
                    className="text-xs p-1 border border-slate-300 rounded font-semibold text-slate-800"
                  >
                    <option value="in_progress">In Progress</option>
                    <option value="resolved">Resolved (Binding)</option>
                    <option value="escalated">Escalated to Legal</option>
                  </select>
                </div>
              </div>
              <textarea
                value={resolutionText}
                onChange={e => setResolutionText(e.target.value)}
                placeholder="Specify agreed deposit refund split, escrow disbursement instructions, or repair liability..."
                className="w-full text-xs p-3 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 leading-relaxed"
                rows={4}
              />
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};
