import { useState } from "react";
import "../../assets/css/profile.css";

const INITIAL_PROFILE = {
  name:     "Commander Rhodes",
  email:    "rhodes@sshms.space",
  role:     "Commander",
  station:  "ISS-Horizon VII",
  joinDate: "2024-01-15",
  badge:    "CR",
};

export default function AdminProfile() {
  const [profile, setProfile]   = useState(INITIAL_PROFILE);
  const [editing, setEditing]   = useState(false);
  const [form, setForm]         = useState(profile);
  const [toast, setToast]       = useState(false);
  const [pwForm, setPwForm]     = useState({ current: "", next: "", confirm: "" });
  const [pwError, setPwError]   = useState("");
  const [pwSuccess, setPwSuccess] = useState(false);
  const [showPw, setShowPw]     = useState({ current: false, next: false, confirm: false });

  const showToast = () => { setToast(true); setTimeout(() => setToast(false), 2400); };

  const handleSave = () => {
    if (!form.name.trim() || !form.email.trim()) return;
    setProfile(form);
    setEditing(false);
    showToast();
  };

  const handlePwChange = () => {
    setPwError("");
    if (!pwForm.current) { setPwError("Enter current password."); return; }
    if (pwForm.next.length < 6) { setPwError("New password must be at least 6 characters."); return; }
    if (pwForm.next !== pwForm.confirm) { setPwError("Passwords do not match."); return; }
    setPwForm({ current: "", next: "", confirm: "" });
    setPwSuccess(true);
    setTimeout(() => setPwSuccess(false), 2400);
  };

  return (
    <div className="ap-root">
      {toast && <div className="ap-toast">✓ Profile updated.</div>}
      {pwSuccess && <div className="ap-toast ap-toast-blue">🔒 Password changed.</div>}

      <div className="ap-header">
        <h1 className="ap-title">Admin Profile</h1>
        <p className="ap-subtitle">Manage your account details</p>
      </div>

      <div className="ap-grid">

        {/* ── Profile Card ── */}
        <div className="ap-card">
          <div className="ap-avatar-row">
            <div className="ap-avatar">{profile.badge}</div>
            <div>
              <p className="ap-name">{profile.name}</p>
              <p className="ap-role">{profile.role} · {profile.station}</p>
              <p className="ap-joined">Joined {profile.joinDate}</p>
            </div>
          </div>

          {!editing ? (
            <>
              <div className="ap-info-list">
                {[
                  { label: "Full Name",    val: profile.name     },
                  { label: "Email",        val: profile.email    },
                  { label: "Role",         val: profile.role     },
                  { label: "Station",      val: profile.station  },
                ].map((r) => (
                  <div key={r.label} className="ap-info-row">
                    <span className="ap-info-label">{r.label}</span>
                    <span className="ap-info-val">{r.val}</span>
                  </div>
                ))}
              </div>
              <button className="ap-edit-btn" onClick={() => { setForm(profile); setEditing(true); }}>
                ✏️ Edit Profile
              </button>
            </>
          ) : (
            <>
              <div className="ap-form">
                {[
                  { key: "name",    label: "Full Name",    ph: "Commander Rhodes" },
                  { key: "email",   label: "Email",        ph: "you@sshms.space"  },
                  { key: "role",    label: "Role",         ph: "Commander"        },
                  { key: "station", label: "Station Name", ph: "ISS-Horizon VII"  },
                ].map(({ key, label, ph }) => (
                  <div key={key} className="ap-form-group">
                    <label className="ap-label">{label}</label>
                    <input
                      className="ap-input"
                      placeholder={ph}
                      value={form[key]}
                      onChange={(e) => setForm({ ...form, [key]: e.target.value })}
                    />
                  </div>
                ))}
              </div>
              <div className="ap-form-actions">
                <button className="ap-cancel-btn" onClick={() => setEditing(false)}>Cancel</button>
                <button className="ap-save-btn"   onClick={handleSave}>Save Changes</button>
              </div>
            </>
          )}
        </div>

        {/* ── Change Password Card ── */}
        <div className="ap-card">
          <p className="ap-card-title">🔒 Change Password</p>
          <div className="ap-form">
            {[
              { key: "current", label: "Current Password" },
              { key: "next",    label: "New Password"     },
              { key: "confirm", label: "Confirm Password" },
            ].map(({ key, label }) => (
              <div key={key} className="ap-form-group">
                <label className="ap-label">{label}</label>
                <div className="ap-pw-wrap">
                  <input
                    type={showPw[key] ? "text" : "password"}
                    className="ap-input"
                    placeholder="••••••••"
                    value={pwForm[key]}
                    onChange={(e) => { setPwForm({ ...pwForm, [key]: e.target.value }); setPwError(""); }}
                  />
                  <button className="ap-pw-toggle" onClick={() => setShowPw((p) => ({ ...p, [key]: !p[key] }))}>
                    {showPw[key] ? "🙈" : "👁️"}
                  </button>
                </div>
              </div>
            ))}
            {pwError && <p className="ap-pw-error">⚠ {pwError}</p>}
          </div>
          <button className="ap-save-btn ap-pw-btn" onClick={handlePwChange}>Update Password</button>
        </div>

      </div>
    </div>
  );
}