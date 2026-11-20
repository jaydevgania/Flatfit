import React, { useState, useEffect } from 'react';
import {
  Building2,
  CheckCircle,
  XCircle,
  PauseCircle,
  PlayCircle,
  Eye,
  Star,
  MapPin,
  ShieldCheck,
  Tag,
  AlertCircle
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { api } from '../services/api';
import { PropertyListing } from '../types';

export const Listings: React.FC = () => {
  const [listings, setListings] = useState<PropertyListing[]>([]);
  const [selectedListing, setSelectedListing] = useState<PropertyListing | null>(null);
  const [rejectModalListing, setRejectModalListing] = useState<PropertyListing | null>(null);
  const [rejectReason, setRejectReason] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  const loadListings = async () => {
    setLoading(true);
    try {
      const data = await api.getListings();
      setListings(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadListings();
  }, []);

  const handleUpdateStatus = async (
    listingId: string,
    status: PropertyListing['status'],
    notes?: string
  ) => {
    try {
      const updated = await api.updateListingStatus(listingId, status, notes);
      setListings(prev => prev.map(l => (l.id === updated.id ? updated : l)));
      if (selectedListing?.id === updated.id) setSelectedListing(updated);
      setRejectModalListing(null);
      setRejectReason('');
    } catch (err) {
      alert('Error updating listing status: ' + err);
    }
  };

  const filteredListings = listings.filter(l => {
    if (statusFilter !== 'all' && l.status !== statusFilter) return false;
    return true;
  });

  const columns: Column<PropertyListing>[] = [
    {
      key: 'title',
      header: 'Listing & Owner',
      render: l => (
        <div className="flex items-start gap-3">
          <div className="w-12 h-12 rounded-lg bg-slate-100 overflow-hidden shrink-0 border border-slate-200">
            {l.photos?.[0]?.url ? (
              <img src={l.photos[0].url} alt="" className="w-full h-full object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-slate-400">
                <Building2 className="w-6 h-6" />
              </div>
            )}
          </div>
          <div>
            <div className="font-semibold text-slate-900 line-clamp-1">{l.title}</div>
            <div className="text-xs text-slate-500 flex items-center gap-1.5 mt-0.5">
              <span>Host: <strong className="text-slate-700">{l.owner_name}</strong></span>
              <span>•</span>
              <span className="capitalize">{l.room_type} Room ({l.bhk_type})</span>
            </div>
          </div>
        </div>
      )
    },
    {
      key: 'locality',
      header: 'Location',
      render: l => (
        <div className="text-xs">
          <div className="font-medium text-slate-800 flex items-center gap-1">
            <MapPin className="w-3.5 h-3.5 text-slate-400" />
            <span>{l.locality}</span>
          </div>
          <div className="text-slate-400 pl-4">{l.city}</div>
        </div>
      )
    },
    {
      key: 'rent',
      header: 'Rent / Deposit',
      render: l => (
        <div className="text-xs">
          <div className="font-bold text-slate-900 font-mono">
            ₹{l.rent.toLocaleString()}/mo
          </div>
          <div className="text-slate-400">
            Dep: ₹{l.deposit.toLocaleString()} • Mnt: ₹{l.maintenance}
          </div>
        </div>
      )
    },
    {
      key: 'quality_score',
      header: 'Quality Score',
      render: l => {
        const score = l.quality_score;
        const color =
          score >= 90
            ? 'text-emerald-700 bg-emerald-50 border-emerald-200'
            : score >= 70
            ? 'text-indigo-700 bg-indigo-50 border-indigo-200'
            : 'text-amber-700 bg-amber-50 border-amber-200';

        return (
          <div className="flex items-center gap-2">
            <span className={`px-2.5 py-0.5 text-xs font-bold rounded-full border ${color}`}>
              {score}/100
            </span>
            {l.is_verified && (
              <span title="Admin Verified Badge">
                <ShieldCheck className="w-4 h-4 text-emerald-600" />
              </span>
            )}
          </div>
        );
      }
    },
    {
      key: 'status',
      header: 'Status',
      render: l => {
        const badgeClass = {
          active: 'bg-emerald-50 text-emerald-700 border-emerald-200',
          paused: 'bg-slate-100 text-slate-600 border-slate-200',
          rejected: 'bg-rose-50 text-rose-700 border-rose-200',
          under_review: 'bg-amber-50 text-amber-700 border-amber-200',
          filled: 'bg-blue-50 text-blue-700 border-blue-200'
        }[l.status];

        return (
          <span className={`px-2.5 py-0.5 text-xs font-semibold rounded-full border capitalize ${badgeClass}`}>
            {l.status.replace('_', ' ')}
          </span>
        );
      }
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: l => (
        <div className="flex items-center gap-1.5">
          <button
            onClick={() => setSelectedListing(l)}
            className="p-1.5 text-slate-600 hover:bg-slate-100 rounded-lg"
            title="Inspect Details"
          >
            <Eye className="w-4 h-4" />
          </button>

          {l.status !== 'active' ? (
            <button
              onClick={() => handleUpdateStatus(l.id, 'active')}
              className="p-1.5 text-emerald-600 hover:bg-emerald-50 rounded-lg"
              title="Approve & Verify Listing"
            >
              <CheckCircle className="w-4 h-4" />
            </button>
          ) : (
            <button
              onClick={() => handleUpdateStatus(l.id, 'paused')}
              className="p-1.5 text-slate-500 hover:bg-slate-100 rounded-lg"
              title="Pause Listing"
            >
              <PauseCircle className="w-4 h-4" />
            </button>
          )}

          {l.status !== 'rejected' && (
            <button
              onClick={() => {
                setRejectModalListing(l);
                setRejectReason('');
              }}
              className="p-1.5 text-rose-600 hover:bg-rose-50 rounded-lg"
              title="Reject Listing"
            >
              <XCircle className="w-4 h-4" />
            </button>
          )}
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">Property Listings & Quality</h2>
          <p className="text-xs text-slate-500">
            Review automated quality scoring, verify photo authenticity, approve or pause live rooms
          </p>
        </div>

        <div className="flex items-center gap-3">
          <select
            value={statusFilter}
            onChange={e => setStatusFilter(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Statuses</option>
            <option value="active">Active & Verified</option>
            <option value="paused">Paused</option>
            <option value="rejected">Rejected / Flagged</option>
          </select>
        </div>
      </div>

      <DataTable
        columns={columns}
        data={filteredListings}
        searchPlaceholder="Search listings by title, locality, host..."
        pageSize={8}
      />

      {/* Inspect Listing Modal */}
      {selectedListing && (
        <Modal
          isOpen={Boolean(selectedListing)}
          onClose={() => setSelectedListing(null)}
          title={selectedListing.title}
          subtitle={`Listing ID: ${selectedListing.id} • Posted by ${selectedListing.owner_name}`}
          maxWidth="xl"
          footer={
            <div className="flex items-center gap-2">
              {selectedListing.status !== 'active' && (
                <button
                  onClick={() => handleUpdateStatus(selectedListing.id, 'active')}
                  className="px-4 py-2 text-xs font-semibold bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
                >
                  Approve & Grant Verified Badge
                </button>
              )}
              {selectedListing.status === 'active' && (
                <button
                  onClick={() => handleUpdateStatus(selectedListing.id, 'paused')}
                  className="px-4 py-2 text-xs font-medium bg-slate-200 text-slate-800 rounded-lg hover:bg-slate-300"
                >
                  Pause Listing
                </button>
              )}
              {selectedListing.status !== 'rejected' && (
                <button
                  onClick={() => {
                    setRejectModalListing(selectedListing);
                    setRejectReason('');
                  }}
                  className="px-4 py-2 text-xs font-semibold bg-rose-600 text-white rounded-lg hover:bg-rose-700"
                >
                  Reject
                </button>
              )}
            </div>
          }
        >
          <div className="space-y-4">
            {/* Photos carousel / grid */}
            {selectedListing.photos && selectedListing.photos.length > 0 && (
              <div className="grid grid-cols-2 gap-2">
                {selectedListing.photos.map((p, i) => (
                  <div key={i} className="h-44 rounded-xl overflow-hidden border border-slate-200">
                    <img src={p.url} alt={p.caption} className="w-full h-full object-cover" />
                  </div>
                ))}
              </div>
            )}

            <div className="grid grid-cols-3 gap-3 p-3 bg-slate-50 rounded-xl text-xs">
              <div>
                <span className="text-slate-400 uppercase text-[10px] font-semibold">Monthly Rent</span>
                <div className="text-sm font-bold text-slate-900 mt-0.5">
                  ₹{selectedListing.rent.toLocaleString()}
                </div>
              </div>
              <div>
                <span className="text-slate-400 uppercase text-[10px] font-semibold">Security Deposit</span>
                <div className="text-sm font-bold text-slate-900 mt-0.5">
                  ₹{selectedListing.deposit.toLocaleString()}
                </div>
              </div>
              <div>
                <span className="text-slate-400 uppercase text-[10px] font-semibold">Quality Index</span>
                <div className="text-sm font-bold text-emerald-700 mt-0.5">
                  {selectedListing.quality_score} / 100
                </div>
              </div>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-1">Address & Details</div>
              <p className="text-xs text-slate-700">
                {selectedListing.address || `${selectedListing.locality}, ${selectedListing.city}`} • Floor: {selectedListing.floor_number || 1}/{selectedListing.total_floors || 5}
              </p>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-1">Description</div>
              <p className="text-xs text-slate-600 bg-slate-50 p-3 rounded-lg leading-relaxed">
                {selectedListing.description}
              </p>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-2">Included Amenities</div>
              <div className="flex flex-wrap gap-1.5">
                {selectedListing.amenities.map((am, i) => (
                  <span
                    key={i}
                    className="px-2.5 py-1 text-[11px] bg-slate-100 text-slate-700 rounded-md font-medium"
                  >
                    ✓ {am}
                  </span>
                ))}
              </div>
            </div>
          </div>
        </Modal>
      )}

      {/* Reject Listing Modal */}
      {rejectModalListing && (
        <Modal
          isOpen={Boolean(rejectModalListing)}
          onClose={() => setRejectModalListing(null)}
          title={`Reject Listing: ${rejectModalListing.title}`}
          maxWidth="md"
          footer={
            <>
              <button
                onClick={() => setRejectModalListing(null)}
                className="px-3 py-1.5 text-xs text-slate-600 hover:bg-slate-100 rounded-lg"
              >
                Cancel
              </button>
              <button
                onClick={() => handleUpdateStatus(rejectModalListing.id, 'rejected', rejectReason)}
                className="px-4 py-2 text-xs font-semibold text-white bg-rose-600 hover:bg-rose-700 rounded-lg"
              >
                Confirm Rejection
              </button>
            </>
          }
        >
          <div className="space-y-3">
            <p className="text-sm text-slate-600">
              Please specify the rejection rationale. This will be communicated to the owner and logged in audit trails.
            </p>
            <textarea
              value={rejectReason}
              onChange={e => setRejectReason(e.target.value)}
              placeholder="e.g. Blurry or stock photos detected, suspicious rent price, incomplete address..."
              className="w-full text-xs p-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-rose-500/20 focus:border-rose-500"
              rows={3}
            />
          </div>
        </Modal>
      )}
    </div>
  );
};
