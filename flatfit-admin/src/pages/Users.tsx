import React, { useState, useEffect } from 'react';
import {
  Users as UsersIcon,
  Shield,
  ShieldCheck,
  ShieldAlert,
  Ban,
  CheckCircle2,
  XCircle,
  ExternalLink,
  Phone,
  Mail,
  Briefcase,
  AlertTriangle,
  Award
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { api } from '../services/api';
import { UserProfile } from '../types';

export const Users: React.FC = () => {
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [selectedUser, setSelectedUser] = useState<UserProfile | null>(null);
  const [banModalUser, setBanModalUser] = useState<UserProfile | null>(null);
  const [banReason, setBanReason] = useState('');
  const [filterGoal, setFilterGoal] = useState<string>('all');
  const [filterStatus, setFilterStatus] = useState<string>('all');
  const [loading, setLoading] = useState(true);

  const loadUsers = async () => {
    setLoading(true);
    try {
      const data = await api.getUsers();
      setUsers(data);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadUsers();
  }, []);

  const handleToggleBan = async () => {
    if (!banModalUser) return;
    try {
      const updated = await api.toggleBanUser(banModalUser.id, banReason);
      setUsers(prev => prev.map(u => (u.id === updated.id ? updated : u)));
      if (selectedUser?.id === updated.id) setSelectedUser(updated);
      setBanModalUser(null);
      setBanReason('');
    } catch (err) {
      alert('Error updating user ban status: ' + err);
    }
  };

  const handleVerifyKyc = async (userId: string) => {
    try {
      const updated = await api.verifyUserKyc(userId);
      setUsers(prev => prev.map(u => (u.id === updated.id ? updated : u)));
      if (selectedUser?.id === updated.id) setSelectedUser(updated);
    } catch (err) {
      alert('Error verifying KYC: ' + err);
    }
  };

  // Filtered dataset
  const filteredUsers = users.filter(u => {
    if (filterGoal !== 'all' && u.housing_goal !== filterGoal) return false;
    if (filterStatus === 'banned' && !u.is_banned) return false;
    if (filterStatus === 'active' && u.is_banned) return false;
    if (filterStatus === 'kyc_verified' && !u.verifications?.kyc) return false;
    return true;
  });

  const columns: Column<UserProfile>[] = [
    {
      key: 'full_name',
      header: 'User',
      render: user => (
        <div className="flex items-center gap-3">
          <img
            src={user.avatar_url || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'}
            alt=""
            className="w-9 h-9 rounded-full object-cover border border-slate-200"
          />
          <div>
            <div className="font-semibold text-slate-900 flex items-center gap-1.5">
              <span>{user.full_name}</span>
              {user.is_banned && (
                <span className="px-1.5 py-0.5 rounded text-[10px] bg-rose-100 text-rose-700 font-bold">
                  BANNED
                </span>
              )}
            </div>
            <div className="text-xs text-slate-400 font-mono">{user.email}</div>
          </div>
        </div>
      )
    },
    {
      key: 'occupation',
      header: 'Profile & Goal',
      render: user => (
        <div>
          <div className="font-medium text-slate-800 capitalize">
            {user.company_or_college || user.occupation || 'Working Professional'}
          </div>
          <div className="text-xs text-slate-400">
            {user.housing_goal === 'need_room' && '🔍 Looking for Room'}
            {user.housing_goal === 'have_room' && '🏠 Has Room to Share'}
            {user.housing_goal === 'looking_together' && '🤝 Team-up for 2BHK'}
          </div>
        </div>
      )
    },
    {
      key: 'city',
      header: 'Location & Budget',
      render: user => (
        <div>
          <div className="text-xs font-medium text-slate-800">
            {user.locality ? `${user.locality}, ${user.city}` : user.city}
          </div>
          <div className="text-xs text-slate-500 font-mono">
            {user.budget_min ? `₹${user.budget_min.toLocaleString()} - ₹${user.budget_max?.toLocaleString()}` : 'Budget Flexible'}
          </div>
        </div>
      )
    },
    {
      key: 'trust_score',
      header: 'Trust Score',
      render: user => {
        const score = user.trust_score || 70;
        const color =
          score >= 90
            ? 'bg-emerald-50 text-emerald-700 border-emerald-200'
            : score >= 75
            ? 'bg-indigo-50 text-indigo-700 border-indigo-200'
            : 'bg-amber-50 text-amber-700 border-amber-200';

        return (
          <div className="flex items-center gap-2">
            <span className={`px-2.5 py-1 rounded-full text-xs font-bold border ${color}`}>
              {score}/100
            </span>
          </div>
        );
      }
    },
    {
      key: 'verifications',
      header: 'Badges',
      render: user => (
        <div className="flex items-center gap-1.5">
          <span
            title={user.verifications?.phone ? 'Phone Verified' : 'Phone Unverified'}
            className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
              user.verifications?.phone
                ? 'bg-emerald-100 text-emerald-700'
                : 'bg-slate-100 text-slate-400'
            }`}
          >
            <Phone className="w-3 h-3" />
          </span>
          <span
            title={user.verifications?.kyc ? 'Govt KYC / Aadhaar Verified' : 'KYC Pending'}
            className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
              user.verifications?.kyc
                ? 'bg-indigo-100 text-indigo-700'
                : 'bg-slate-100 text-slate-400'
            }`}
          >
            <ShieldCheck className="w-3 h-3" />
          </span>
          <span
            title={
              user.verifications?.employer_email || user.verifications?.college_email
                ? 'Work/Edu Domain Verified'
                : 'Domain Pending'
            }
            className={`w-6 h-6 rounded-full flex items-center justify-center text-xs ${
              user.verifications?.employer_email || user.verifications?.college_email
                ? 'bg-sky-100 text-sky-700'
                : 'bg-slate-100 text-slate-400'
            }`}
          >
            <Briefcase className="w-3 h-3" />
          </span>
        </div>
      )
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: user => (
        <div className="flex items-center gap-2">
          <button
            onClick={() => setSelectedUser(user)}
            className="px-2.5 py-1 text-xs font-medium rounded-lg text-slate-600 bg-slate-100 hover:bg-slate-200 transition-colors"
          >
            Inspect
          </button>
          <button
            onClick={() => {
              setBanModalUser(user);
              setBanReason(user.ban_reason || '');
            }}
            className={`px-2.5 py-1 text-xs font-medium rounded-lg transition-colors ${
              user.is_banned
                ? 'text-emerald-700 bg-emerald-50 hover:bg-emerald-100'
                : 'text-rose-700 bg-rose-50 hover:bg-rose-100'
            }`}
          >
            {user.is_banned ? 'Unban' : 'Ban'}
          </button>
        </div>
      )
    }
  ];

  return (
    <div className="space-y-6">
      {/* Header Controls */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">User Directory & Verification</h2>
          <p className="text-xs text-slate-500">
            Manage profiles, verify Aadhaar/KYC credentials, and enforce trust & safety rules
          </p>
        </div>

        <div className="flex items-center gap-3">
          <select
            value={filterGoal}
            onChange={e => setFilterGoal(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Housing Goals</option>
            <option value="need_room">Need Room</option>
            <option value="have_room">Have Room</option>
            <option value="looking_together">Looking Together</option>
          </select>

          <select
            value={filterStatus}
            onChange={e => setFilterStatus(e.target.value)}
            className="px-3 py-1.5 text-xs font-medium bg-white border border-slate-300 rounded-lg text-slate-700"
          >
            <option value="all">All Statuses</option>
            <option value="active">Active Only</option>
            <option value="banned">Banned Users</option>
            <option value="kyc_verified">KYC Verified Only</option>
          </select>
        </div>
      </div>

      {/* Data Table */}
      <DataTable
        columns={columns}
        data={filteredUsers}
        searchPlaceholder="Search by name, email, company, locality..."
        pageSize={8}
      />

      {/* Inspect User Profile Modal */}
      {selectedUser && (
        <Modal
          isOpen={Boolean(selectedUser)}
          onClose={() => setSelectedUser(null)}
          title={`User Dossier: ${selectedUser.full_name}`}
          subtitle={`ID: ${selectedUser.id} • Joined: ${new Date(selectedUser.created_at).toLocaleDateString()}`}
          maxWidth="lg"
          footer={
            <>
              {!selectedUser.verifications?.kyc && (
                <button
                  onClick={() => handleVerifyKyc(selectedUser.id)}
                  className="px-4 py-2 text-xs font-medium bg-indigo-600 text-white rounded-lg hover:bg-indigo-700"
                >
                  Approve KYC Manually
                </button>
              )}
              <button
                onClick={() => {
                  setBanModalUser(selectedUser);
                  setBanReason(selectedUser.ban_reason || '');
                }}
                className={`px-4 py-2 text-xs font-medium rounded-lg ${
                  selectedUser.is_banned
                    ? 'bg-emerald-600 text-white hover:bg-emerald-700'
                    : 'bg-rose-600 text-white hover:bg-rose-700'
                }`}
              >
                {selectedUser.is_banned ? 'Unban User' : 'Ban User Account'}
              </button>
            </>
          }
        >
          <div className="space-y-4">
            <div className="flex items-center gap-4 p-4 bg-slate-50 rounded-xl">
              <img
                src={selectedUser.avatar_url || 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'}
                alt=""
                className="w-16 h-16 rounded-full object-cover border-2 border-white shadow"
              />
              <div className="flex-1">
                <h4 className="text-base font-bold text-slate-900">{selectedUser.full_name}</h4>
                <p className="text-xs text-slate-500">{selectedUser.email}</p>
                <div className="flex items-center gap-2 mt-2">
                  <span className="px-2 py-0.5 text-xs font-semibold rounded bg-emerald-100 text-emerald-800">
                    Trust Score: {selectedUser.trust_score}/100
                  </span>
                  <span className="text-xs text-slate-500">
                    Profile Completeness: {selectedUser.profile_completion}%
                  </span>
                </div>
              </div>
            </div>

            {selectedUser.is_banned && (
              <div className="p-3 bg-rose-50 border border-rose-200 rounded-lg text-xs text-rose-800 flex items-start gap-2">
                <AlertTriangle className="w-4 h-4 text-rose-600 shrink-0 mt-0.5" />
                <div>
                  <strong>User Suspended:</strong> {selectedUser.ban_reason || 'Administrative restriction'}
                </div>
              </div>
            )}

            <div className="grid grid-cols-2 gap-3 text-xs">
              <div className="p-3 border border-slate-200 rounded-lg">
                <div className="text-slate-400 uppercase font-semibold text-[10px]">Occupation / Org</div>
                <div className="font-semibold text-slate-800 mt-1">
                  {selectedUser.company_or_college || 'Self Employed'} ({selectedUser.occupation})
                </div>
              </div>
              <div className="p-3 border border-slate-200 rounded-lg">
                <div className="text-slate-400 uppercase font-semibold text-[10px]">Target Locality</div>
                <div className="font-semibold text-slate-800 mt-1">
                  {selectedUser.locality || selectedUser.city}
                </div>
              </div>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-1">User Bio</div>
              <p className="text-xs bg-slate-50 p-3 rounded-lg text-slate-700 italic">
                "{selectedUser.bio || 'No bio provided'}"
              </p>
            </div>

            <div>
              <div className="text-xs font-semibold uppercase text-slate-400 mb-2">
                DPDP & Verification Badges
              </div>
              <div className="grid grid-cols-2 gap-2 text-xs">
                <div className="flex items-center justify-between p-2.5 rounded bg-slate-50 border border-slate-200">
                  <span>Phone OTP Verified</span>
                  {selectedUser.verifications?.phone ? (
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  ) : (
                    <XCircle className="w-4 h-4 text-slate-400" />
                  )}
                </div>
                <div className="flex items-center justify-between p-2.5 rounded bg-slate-50 border border-slate-200">
                  <span>Govt KYC (Aadhaar Masked)</span>
                  {selectedUser.verifications?.kyc ? (
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  ) : (
                    <XCircle className="w-4 h-4 text-slate-400" />
                  )}
                </div>
                <div className="flex items-center justify-between p-2.5 rounded bg-slate-50 border border-slate-200">
                  <span>Corporate / Edu Domain</span>
                  {selectedUser.verifications?.employer_email || selectedUser.verifications?.college_email ? (
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  ) : (
                    <XCircle className="w-4 h-4 text-slate-400" />
                  )}
                </div>
                <div className="flex items-center justify-between p-2.5 rounded bg-slate-50 border border-slate-200">
                  <span>LinkedIn Authenticated</span>
                  {selectedUser.verifications?.linkedin ? (
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                  ) : (
                    <XCircle className="w-4 h-4 text-slate-400" />
                  )}
                </div>
              </div>
            </div>
          </div>
        </Modal>
      )}

      {/* Ban / Unban Confirmation Modal */}
      {banModalUser && (
        <Modal
          isOpen={Boolean(banModalUser)}
          onClose={() => setBanModalUser(null)}
          title={banModalUser.is_banned ? `Unban ${banModalUser.full_name}` : `Ban ${banModalUser.full_name}`}
          maxWidth="md"
          footer={
            <>
              <button
                onClick={() => setBanModalUser(null)}
                className="px-3 py-1.5 text-xs text-slate-600 hover:bg-slate-100 rounded-lg"
              >
                Cancel
              </button>
              <button
                onClick={handleToggleBan}
                className={`px-4 py-2 text-xs font-semibold text-white rounded-lg ${
                  banModalUser.is_banned
                    ? 'bg-emerald-600 hover:bg-emerald-700'
                    : 'bg-rose-600 hover:bg-rose-700'
                }`}
              >
                {banModalUser.is_banned ? 'Confirm Re-Activation' : 'Enforce Account Ban'}
              </button>
            </>
          }
        >
          <div className="space-y-3">
            <p className="text-sm text-slate-600">
              {banModalUser.is_banned
                ? `Are you sure you want to restore access for ${banModalUser.full_name}? Their profile and active listings will be unhidden.`
                : `Banning ${banModalUser.full_name} will immediately revoke active sessions, hide listings, and prevent messaging.`}
            </p>
            {!banModalUser.is_banned && (
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1">
                  Reason for Ban (Logged in Audit Trail):
                </label>
                <textarea
                  value={banReason}
                  onChange={e => setBanReason(e.target.value)}
                  placeholder="e.g. Commercial broker spam, advance deposit fraud attempt, abusive conduct..."
                  className="w-full text-xs p-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-rose-500/20 focus:border-rose-500"
                  rows={3}
                />
              </div>
            )}
          </div>
        </Modal>
      )}
    </div>
  );
};
