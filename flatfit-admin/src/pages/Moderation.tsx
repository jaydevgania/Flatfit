import React, { useState, useEffect } from 'react';
import {
  ShieldAlert,
  AlertTriangle,
  CheckCircle,
  XCircle,
  FileText,
  Image as ImageIcon,
  MessageSquare,
  Flag,
  UserX,
  Bot
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { api } from '../services/api';
import { ModerationQueueItem } from '../types';

export const Moderation: React.FC = () => {
  const [items, setItems] = useState<ModerationQueueItem[]>([]);
  const [selectedItem, setSelectedItem] = useState<ModerationQueueItem | null>(null);
  const [reviewNote, setReviewNote] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('pending');
  const [typeFilter, setTypeFilter] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  const loadQueue = async () => {
    setLoading(true);
    try {
      const data = await api.getModerationQueue();
      setItems(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadQueue();
  }, []);

  const handleReview = async (itemId: string, action: 'approved' | 'rejected') => {
    try {
      const updated = await api.reviewModerationItem(itemId, action, reviewNote);
      setItems(prev => prev.map(m => (m.id === updated.id ? updated : m)));
      setSelectedItem(null);
      setReviewNote('');
    } catch (err) {
      alert('Error updating moderation item: ' + err);
    }
  };

  const filteredItems = items.filter(item => {
    if (statusFilter !== 'all' && item.status !== statusFilter) return false;
    if (typeFilter !== 'all' && item.type !== typeFilter) return false;
    return true;
  });

  const getTypeIcon = (type: ModerationQueueItem['type']) => {
    switch (type) {
      case 'photo':
        return <ImageIcon className="w-4 h-4 text-sky-600" />;
      case 'text':
        return <MessageSquare className="w-4 h-4 text-purple-600" />;
      case 'listing':
        return <FileText className="w-4 h-4 text-amber-600" />;
      case 'report':
        return <Flag className="w-4 h-4 text-rose-600" />;
    }
  };

  const columns: Column<ModerationQueueItem>[] = [
    {
      key: 'type',
      header: 'Type & Priority',
      render: item => {
        const priorityColors = {
          3: 'bg-rose-100 text-rose-800 border-rose-200',
          2: 'bg-amber-100 text-amber-800 border-amber-200',
          1: 'bg-blue-100 text-blue-800 border-blue-200',
          0: 'bg-slate-100 text-slate-700 border-slate-200'
        }[item.priority] || 'bg-slate-100 text-slate-700';

        const priorityLabel = item.priority === 3 ? 'URGENT' : item.priority === 2 ? 'HIGH' : 'MEDIUM';

        return (
          <div className="flex items-center gap-2">
            <div className="p-1.5 rounded-lg bg-slate-100">{getTypeIcon(item.type)}</div>
            <div>
              <div className="capitalize font-semibold text-slate-900 text-xs">{item.type}</div>
              <span className={`px-1.5 py-0.2 rounded text-[10px] font-bold border ${priorityColors}`}>
                {priorityLabel}
              </span>
            </div>
          </div>
        );
      }
    },
    {
      key: 'content_preview',
      header: 'Flagged Content Preview',
      render: item => (
        <div className="max-w-md">
          <p className="text-xs text-slate-800 font-medium line-clamp-2">{item.content_preview}</p>
          {item.auto_flagged && (
            <div className="flex items-center gap-1.5 text-[11px] text-amber-700 mt-1 font-medium">
              <Bot className="w-3.5 h-3.5 text-amber-600" />
              <span>AI Flag: {item.auto_flag_reason}</span>
            </div>
          )}
        </div>
      )
    },
    {
      key: 'reported_user_name',
      header: 'Target User',
      render: item => (
        <div className="text-xs">
          <div className="font-semibold text-slate-900">{item.reported_user_name || 'Anonymous User'}</div>
          <div className="text-slate-400 font-mono text-[10px]">ID: {item.reported_user_id || 'N/A'}</div>
        </div>
      )
    },
    {
      key: 'status',
      header: 'Status',
      render: item => {
        const badge = {
          pending: 'bg-amber-50 text-amber-700 border-amber-200',
          approved: 'bg-emerald-50 text-emerald-700 border-emerald-200',
          rejected: 'bg-rose-50 text-rose-700 border-rose-200'
        }[item.status];

        return (
          <span className={`px-2.5 py-0.5 rounded-full text-xs font-semibold border capitalize ${badge}`}>
            {item.status}
          </span>
        );
      }
    },
    {
      key: 'actions',
      header: 'Review',
      sortable: false,
      render: item => (
        <div className="flex items-center gap-2">
          {item.status === 'pending' ? (
            <>
              <button
                onClick={() => {
                  setSelectedItem(item);
                  setReviewNote('');
                }}
                className="px-2.5 py-1 text-xs font-medium bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg"
              >
                Inspect
              </button>
              <button
                onClick={() => handleReview(item.id, 'approved')}
                className="p-1 text-emerald-600 hover:bg-emerald-50 rounded"
                title="Dismiss Flag (Approve Content)"
              >
                <CheckCircle className="w-4 h-4" />
              </button>
              <button
                onClick={() => handleReview(item.id, 'rejected')}
                className="p-1 text-rose-600 hover:bg-rose-50 rounded"
                title="Remove Content / Violate Rules"
              >
                <XCircle className="w-4 h-4" />
              </button>
            </>
          ) : (
            <span className="text-[11px] text-slate-400 italic">
              Reviewed by {item.reviewed_by || 'Admin'}
            </span>
          )}
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">Trust & Safety Moderation Queue</h2>
          <p className="text-xs text-slate-500">
            Automated LLM/vision flagging for stock photos, off-platform payment schemes, and community reports
          </p>
        </div>

        <div className="flex items-center gap-3">
          <select
            value={statusFilter}
            onChange={e => setStatusFilter(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="pending">Pending Review Only</option>
            <option value="all">All Moderation Items</option>
            <option value="approved">Approved / Dismissed</option>
            <option value="rejected">Rejected / Taken Down</option>
          </select>

          <select
            value={typeFilter}
            onChange={e => setTypeFilter(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Content Types</option>
            <option value="photo">Photos Only</option>
            <option value="text">Chat Messages</option>
            <option value="report">User Reports</option>
            <option value="listing">Listings</option>
          </select>
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredItems}
        searchPlaceholder="Search moderation items by user, content preview, or reason..."
        pageSize={8}
      />

      {/* Item Inspection & Resolution Modal */}
      {selectedItem && (
        <Modal
          isOpen={Boolean(selectedItem)}
          onClose={() => setSelectedItem(null)}
          title={`Moderation Docket #${selectedItem.id}`}
          subtitle={`Reported on: ${new Date(selectedItem.created_at).toLocaleString()}`}
          maxWidth="lg"
          footer={
            <div className="flex items-center gap-2">
              <button
                onClick={() => handleReview(selectedItem.id, 'approved')}
                className="px-4 py-2 text-xs font-semibold bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
              >
                Dismiss Flag (Allow Content)
              </button>
              <button
                onClick={() => handleReview(selectedItem.id, 'rejected')}
                className="px-4 py-2 text-xs font-semibold bg-rose-600 text-white rounded-lg hover:bg-rose-700"
              >
                Enforce Violation (Takedown)
              </button>
            </div>
          }
        >
          <div className="space-y-4">
            <div className="p-3 bg-amber-50 border border-amber-200 rounded-xl text-xs text-amber-900 flex items-start gap-2">
              <AlertTriangle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <div>
                <strong>Flag Reason:</strong> {selectedItem.auto_flag_reason || 'Community User Report filed against terms of service'}
              </div>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-1">
                Content Body / Preview
              </div>
              <div className="p-4 bg-slate-900 text-slate-100 rounded-xl font-mono text-xs whitespace-pre-wrap leading-relaxed">
                {selectedItem.content_preview}
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3 text-xs">
              <div className="p-3 bg-slate-50 border border-slate-200 rounded-lg">
                <span className="text-slate-400 font-semibold uppercase text-[10px]">Target User</span>
                <div className="font-bold text-slate-900 mt-1">{selectedItem.reported_user_name}</div>
                <div className="text-slate-400 text-[10px]">ID: {selectedItem.reported_user_id}</div>
              </div>
              <div className="p-3 bg-slate-50 border border-slate-200 rounded-lg">
                <span className="text-slate-400 font-semibold uppercase text-[10px]">Reported By</span>
                <div className="font-bold text-slate-900 mt-1">
                  {selectedItem.reported_by ? `User (${selectedItem.reported_by})` : 'Automated Sentinel Guard'}
                </div>
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Moderator Review Notes (Logged for Audit & Transparency):
              </label>
              <textarea
                value={reviewNote}
                onChange={e => setReviewNote(e.target.value)}
                placeholder="Enter actions taken, user warned status, or resolution comments..."
                className="w-full text-xs p-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500"
                rows={3}
              />
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};
