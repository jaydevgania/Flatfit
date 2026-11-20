import React, { useState } from 'react';
import { Sidebar, PageId } from './components/Sidebar';
import { Header } from './components/Header';
import { Dashboard } from './pages/Dashboard';
import { Users } from './pages/Users';
import { Listings } from './pages/Listings';
import { Moderation } from './pages/Moderation';
import { Disputes } from './pages/Disputes';
import { B2BCorporate } from './pages/B2BCorporate';
import { B2BColleges } from './pages/B2BColleges';
import { B2BOperators } from './pages/B2BOperators';
import { AuditLogs } from './pages/AuditLogs';
import { MobileAppSimulator } from './pages/MobileAppSimulator';

export const App: React.FC = () => {
  const [currentPage, setCurrentPage] = useState<PageId>('mobile-app');
  const [selectedCity, setSelectedCity] = useState('Mumbai');
  const [refreshKey, setRefreshKey] = useState(0);

  const getPageMeta = (page: PageId) => {
    switch (page) {
      case 'mobile-app':
        return {
          title: 'FlatFit Mobile App (Interactive Phone Simulator)',
          subtitle: 'Interactive live demo of the user journey: Discovery swipe, Quiz, Chat & Meet, House Hub, and Trust'
        };
      case 'dashboard':
        return {
          title: 'Analytics & North-Star Metrics',
          subtitle: 'Compatibility funnel telemetry, 30/90-day retention, and Mumbai micro-market demand'
        };
      case 'users':
        return {
          title: 'User Directory & Verification',
          subtitle: 'Trust score distribution, Aadhaar/KYC credentials, and user account actions'
        };
      case 'listings':
        return {
          title: 'Listing Quality & Verification',
          subtitle: 'Automated quality grading, photo review, and active inventory controls'
        };
      case 'moderation':
        return {
          title: 'Trust & Safety Moderation Queue',
          subtitle: 'Scam prevention, stock image detection, and community violation tickets'
        };
      case 'disputes':
        return {
          title: 'Deposit & Lease Dispute Desk',
          subtitle: 'Arbitration desk for security deposit withholding and notice period breaches'
        };
      case 'b2b-corporate':
        return {
          title: 'Corporate Relocation Portal',
          subtitle: 'Enterprise cohorts, email auto-verification, and employee roommate compatibility'
        };
      case 'b2b-colleges':
        return {
          title: 'College Housing & Safety Rings',
          subtitle: 'Campus-partnered student flatmate rings, guardian verification, and safety indices'
        };
      case 'b2b-operators':
        return {
          title: 'PG & Co-Living Inventory & Allocation',
          subtitle: 'Bed-level inventory management and algorithmic roommate compatibility allocation'
        };
      case 'audit-logs':
        return {
          title: 'Security Audit & Compliance Logs',
          subtitle: 'Immutable record of all admin interventions, permission changes, and financial rulings'
        };
    }
  };

  const { title, subtitle } = getPageMeta(currentPage);

  return (
    <div className="flex min-h-screen bg-slate-50 font-sans">
      {/* Sidebar Navigation */}
      <Sidebar
        currentPage={currentPage}
        onSelectPage={setCurrentPage}
        pendingModerationCount={2}
        openDisputesCount={1}
      />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0">
        <Header
          title={title}
          subtitle={subtitle}
          selectedCity={selectedCity}
          onCityChange={setSelectedCity}
          onRefresh={() => setRefreshKey(prev => prev + 1)}
        />

        <main key={refreshKey} className="flex-1 p-8 overflow-y-auto max-w-7xl w-full mx-auto">
          {currentPage === 'mobile-app' && <MobileAppSimulator />}
          {currentPage === 'dashboard' && <Dashboard />}
          {currentPage === 'users' && <Users />}
          {currentPage === 'listings' && <Listings />}
          {currentPage === 'moderation' && <Moderation />}
          {currentPage === 'disputes' && <Disputes />}
          {currentPage === 'b2b-corporate' && <B2BCorporate />}
          {currentPage === 'b2b-colleges' && <B2BColleges />}
          {currentPage === 'b2b-operators' && <B2BOperators />}
          {currentPage === 'audit-logs' && <AuditLogs />}
        </main>
      </div>
    </div>
  );
};

export default App;
