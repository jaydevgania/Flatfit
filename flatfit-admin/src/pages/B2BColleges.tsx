import React, { useState, useEffect } from 'react';
import {
  GraduationCap,
  ShieldCheck,
  Users,
  MapPin,
  CheckCircle,
  Phone,
  BookOpen,
  ChevronRight,
  Plus,
  Shield
} from 'lucide-react';
import { DataTable, Column } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { MetricCard } from '../components/MetricCard';
import { api } from '../services/api';
import { CollegeAccount, CollegeBatch, StudentHousingProfile } from '../types';

export const B2BColleges: React.FC = () => {
  const [colleges, setColleges] = useState<CollegeAccount[]>([]);
  const [batches, setBatches] = useState<CollegeBatch[]>([]);
  const [students, setStudents] = useState<StudentHousingProfile[]>([]);
  const [selectedCollege, setSelectedCollege] = useState<CollegeAccount | null>(null);
  const [loading, setLoading] = useState(true);

  const loadData = async () => {
    setLoading(true);
    try {
      const data = await api.getCollegeAccounts();
      setColleges(data.colleges);
      setBatches(data.batches);
      setStudents(data.students);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const collegeColumns: Column<CollegeAccount>[] = [
    {
      key: 'institution_name',
      header: 'University / Institute',
      render: col => (
        <div>
          <div className="font-bold text-slate-900">{col.institution_name}</div>
          <div className="text-xs text-slate-400 flex items-center gap-1 mt-0.5">
            <MapPin className="w-3 h-3" />
            <span>
              {col.campus_locality}, {col.city}
            </span>
          </div>
        </div>
      )
    },
    {
      key: 'safety_score',
      header: 'Campus Vicinity Safety',
      render: col => (
        <div className="flex items-center gap-1.5">
          <span className="px-2.5 py-0.5 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200">
            {col.safety_score}/100 Safe
          </span>
        </div>
      )
    },
    {
      key: 'students',
      header: 'Enrolled / Verified',
      render: col => (
        <div className="text-xs">
          <div className="font-semibold text-slate-800">
            {col.verified_students_count} verified students
          </div>
          <div className="text-slate-400">Total: {col.student_count} registered</div>
        </div>
      )
    },
    {
      key: 'rings',
      header: 'Curated Batch Rings',
      render: col => (
        <span className="px-2.5 py-1 text-xs font-semibold rounded-lg bg-indigo-50 text-indigo-700 border border-indigo-200">
          {col.curated_rings_count} Peer Rings
        </span>
      )
    },
    {
      key: 'actions',
      header: 'Actions',
      sortable: false,
      render: col => (
        <button
          onClick={() => setSelectedCollege(col)}
          className="px-3 py-1 text-xs font-medium bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg flex items-center gap-1"
        >
          View Batches & Housing <ChevronRight className="w-3 h-3" />
        </button>
      )
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-lg font-bold text-slate-900 tracking-tight">
            College & University Off-Campus Housing
          </h2>
          <p className="text-xs text-slate-500">
            Safe flatmate matchmaking rings for universities, guardian verification, and safety-audited student localities
          </p>
        </div>

        <span className="text-xs font-semibold px-3 py-1.5 rounded-lg bg-slate-100 text-slate-700 border border-slate-200">
          Academic Year: 2026-27
        </span>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <MetricCard
          label="Partner Colleges & Universities"
          value="18 Campuses"
          change={12.5}
          trend="up"
          subtext="Mumbai, Pune & Bengaluru hubs"
          icon={GraduationCap}
        />
        <MetricCard
          label="Guardian Verified Students"
          value="96.2%"
          change={4.8}
          trend="up"
          subtext="DPDP compliant parental consent"
          icon={ShieldCheck}
        />
        <MetricCard
          label="Avg Student Off-Campus Rent"
          value="₹18,400"
          change={-6.2}
          trend="up"
          subtext="Curated 2BHK/3BHK shared room cost"
          icon={BookOpen}
        />
      </div>

      <DataTable
        columns={collegeColumns}
        data={colleges}
        searchPlaceholder="Search universities, campus localities..."
        pageSize={6}
      />

      {/* College Batches & Student Rings Modal */}
      {selectedCollege && (
        <Modal
          isOpen={Boolean(selectedCollege)}
          onClose={() => setSelectedCollege(null)}
          title={`${selectedCollege.institution_name} — Student Housing Hub`}
          subtitle={`Vicinity Safety Index: ${selectedCollege.safety_score}/100 • Campus: ${selectedCollege.campus_locality}`}
          maxWidth="xl"
          footer={
            <button
              onClick={() => setSelectedCollege(null)}
              className="px-4 py-2 text-xs font-medium bg-slate-100 text-slate-700 rounded-lg hover:bg-slate-200"
            >
              Close
            </button>
          }
        >
          <div className="space-y-4">
            <div className="grid grid-cols-2 gap-3 text-xs">
              {batches.map(b => (
                <div key={b.id} className="p-3 bg-slate-50 rounded-xl border border-slate-200">
                  <div className="font-bold text-slate-900">{b.name}</div>
                  <div className="text-slate-500 text-[11px] mt-0.5">
                    {b.degree} • {b.semester}
                  </div>
                  <div className="mt-2 text-xs flex items-center justify-between">
                    <span className="text-emerald-700 font-semibold">
                      {b.matched_count} / {b.enrolled_students} Placed
                    </span>
                    <span className="px-1.5 py-0.5 text-[10px] rounded bg-purple-100 text-purple-700 font-bold">
                      {b.gender_segregated ? 'Gender-Segregated' : 'Co-ed'}
                    </span>
                  </div>
                </div>
              ))}
            </div>

            <div>
              <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider mb-2">
                Active Student Housing Profiles & Guardian Status
              </h4>
              <div className="divide-y divide-slate-100 border border-slate-200 rounded-xl overflow-hidden text-xs">
                {students.map(stu => (
                  <div key={stu.id} className="p-3 bg-white hover:bg-slate-50 flex items-center justify-between">
                    <div>
                      <div className="font-semibold text-slate-900 flex items-center gap-1.5">
                        <span>{stu.student_name}</span>
                        <span className="text-[10px] text-slate-400">({stu.roll_number})</span>
                      </div>
                      <div className="text-[11px] text-slate-500">
                        {stu.email} • Budget: ₹{stu.budget_monthly.toLocaleString()}/mo
                      </div>
                    </div>
                    <div className="text-right">
                      {stu.roommate_matched ? (
                        <div>
                          <div className="text-emerald-700 font-bold">Matched with {stu.roommate_matched}</div>
                          <span className="text-[10px] text-slate-400">
                            {stu.match_compatibility}% Score • Guardian: Verified ({stu.guardian_phone})
                          </span>
                        </div>
                      ) : (
                        <div className="flex items-center gap-1 justify-end text-amber-700">
                          <span className="text-[11px] font-semibold">Searching Roommates</span>
                        </div>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};
