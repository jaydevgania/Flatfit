import React, { useState, useEffect } from 'react';
import {
  FileText,
  Shield,
  Search,
  Clock,
  User,
  ArrowRight,
  Code,
  Eye,
  CheckCircle2,
  Lock
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { api } from '../services/api';
import { AuditLog } from '../types';

export const AuditLogs: React.FC = () => {
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [selectedLog, setSelectedLog] = useState<AuditLog | null>(null);
  const [filterEntity, setFilterEntity] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  const loadLogs = async () => {
    setLoading(true);
    try {
      const data = await api.getAuditLogs();
      setLogs(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadLogs();
  }, []);

  const filteredLogs = logs.filter(log => {
    if (filterEntity !== 'all' && log.entity_type !== filterEntity) return false;
    return true;
  });

  const columns: Column<AuditLog>[] = [
    {
      key: 'created_at',
      header: 'Timestamp',
      render: log => (
        <div className="text-xs">
          <div className="font-semibold text-slate-900 font-mono">
            {new Date(log.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' })}
          </div>
          <div className="text-slate-400">
            {new Date(log.created_at).toLocaleDateString()}
          </div>
        </div>
      )
    },
    {
      key: 'admin_name',
      header: 'Admin Actor',
      render: log => (
        <div className="text-xs">
          <div className="font-semibold text-slate-800 flex items-center gap-1.5">
            <User className="w-3.5 h-3.5 text-slate-400" />
            <span>{log.admin_name || 'System / Auto'}</span>
          </div>
          <div className="text-[10px] text-slate-400 font-mono">IP: {log.ip_address || '127.0.0.1'}</div>
        </div>
      )
    },
    {
      key: 'action',
      header: 'Action Event',
      render: log => (
        <span className="font-mono text-xs font-semibold px-2 py-0.5 rounded bg-slate-100 text-slate-800 border border-slate-200">
          {log.action}
        </span>
      )
    },
    {
      key: 'entity_type',
      header: 'Entity & Target ID',
      render: log => (
        <div className="text-xs">
          <span className="capitalize font-medium text-slate-700">{log.entity_type}</span>
          <div className="font-mono text-[11px] text-slate-400">{log.entity_id || 'Global'}</div>
        </div>
      )
    },
    {
      key: 'actions',
      header: 'Payload Diff',
      sortable: false,
      render: log => (
        <button
          onClick={() => setSelectedLog(log)}
          className="px-2.5 py-1 text-xs font-medium bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg flex items-center gap-1"
        >
          <Eye className="w-3.5 h-3.5" />
          <span>Inspect Diff</span>
        </button>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">
            Security Audit Trail & Compliance Log
          </h2>
          <p className="text-xs text-slate-500">
            Immutable log of all administrative actions, KYC access, policy bans, and dispute payouts
          </p>
        </div>

        <div className="flex items-center gap-3">
          <select
            value={filterEntity}
            onChange={e => setFilterEntity(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Entity Types</option>
            <option value="profile">User Profiles</option>
            <option value="listing">Listings</option>
            <option value="dispute">Disputes</option>
            <option value="moderation_queue">Moderation Queue</option>
            <option value="verification">KYC / Verification</option>
            <option value="corporate_account">Corporate Accounts</option>
          </select>
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredLogs}
        searchPlaceholder="Search audit events by action, admin, entity..."
        pageSize={10}
      />

      {/* Inspect Audit Log Modal */}
      {selectedLog && (
        <Modal
          isOpen={Boolean(selectedLog)}
          onClose={() => setSelectedLog(null)}
          title={`Audit Record #${selectedLog.id}`}
          subtitle={`Action: ${selectedLog.action} • Logged at ${new Date(selectedLog.created_at).toLocaleString()}`}
          maxWidth="lg"
          footer={
            <button
              onClick={() => setSelectedLog(null)}
              className="px-4 py-2 text-xs font-medium bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200"
            >
              Close
            </button>
          }
        >
          <div className="space-y-4 text-xs">
            <div className="grid grid-cols-2 gap-3 p-3 bg-slate-50 rounded-xl border border-slate-200">
              <div>
                <span className="text-slate-400 font-semibold uppercase text-[10px]">Actor</span>
                <div className="font-bold text-slate-900 mt-0.5">{selectedLog.admin_name}</div>
                <div className="text-[10px] text-slate-400 font-mono">IP: {selectedLog.ip_address}</div>
              </div>
              <div>
                <span className="text-slate-400 font-semibold uppercase text-[10px]">Target</span>
                <div className="font-bold text-slate-900 mt-0.5 capitalize">{selectedLog.entity_type}</div>
                <div className="text-[10px] text-slate-400 font-mono">ID: {selectedLog.entity_id}</div>
              </div>
            </div>

            <div>
              <div className="font-semibold text-slate-700 mb-1 flex items-center gap-1.5">
                <Code className="w-4 h-4 text-slate-400" />
                <span>State Transition Diff (Before & After):</span>
              </div>
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <div className="text-[10px] font-bold uppercase text-slate-400 mb-1">Old State</div>
                  <pre className="p-3 bg-slate-900 text-rose-300 rounded-lg font-mono text-[11px] overflow-x-auto max-h-48">
                    {JSON.stringify(selectedLog.old_data || {}, null, 2)}
                  </pre>
                </div>
                <div>
                  <div className="text-[10px] font-bold uppercase text-slate-400 mb-1">New State</div>
                  <pre className="p-3 bg-slate-900 text-emerald-300 rounded-lg font-mono text-[11px] overflow-x-auto max-h-48">
                    {JSON.stringify(selectedLog.new_data || {}, null, 2)}
                  </pre>
                </div>
              </div>
            </div>

            {selectedLog.metadata && Object.keys(selectedLog.metadata).length > 0 && (
              <div>
                <div className="text-[10px] font-bold uppercase text-slate-400 mb-1">Metadata</div>
                <pre className="p-2.5 bg-slate-100 text-slate-700 rounded-lg font-mono text-[11px]">
                  {JSON.stringify(selectedLog.metadata, null, 2)}
                </pre>
              </div>
            )}
          </div>
        </Modal>
      )}
    </div>
  );
};
