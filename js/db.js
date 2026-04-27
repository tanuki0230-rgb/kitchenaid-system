'use strict';

const DB = {
  uid() {
    return Date.now().toString(36) + Math.random().toString(36).slice(2, 7);
  },

  nextNum(prefix) {
    const yr = new Date().getFullYear();
    const key = `ka_seq_${prefix}_${yr}`;
    const n = parseInt(localStorage.getItem(key) || '0') + 1;
    localStorage.setItem(key, String(n));
    return `${prefix}-${yr}-${String(n).padStart(4, '0')}`;
  },

  // ---- Parts / Stock ----
  getParts() {
    return JSON.parse(localStorage.getItem('ka_parts') || '[]');
  },
  addPart(p) {
    const list = this.getParts();
    p.id = this.uid();
    p.createdAt = new Date().toISOString();
    list.push(p);
    localStorage.setItem('ka_parts', JSON.stringify(list));
    return p;
  },
  updatePart(id, data) {
    const list = this.getParts();
    const i = list.findIndex(x => x.id === id);
    if (i < 0) return null;
    list[i] = { ...list[i], ...data, updatedAt: new Date().toISOString() };
    localStorage.setItem('ka_parts', JSON.stringify(list));
    return list[i];
  },
  deletePart(id) {
    localStorage.setItem('ka_parts', JSON.stringify(this.getParts().filter(p => p.id !== id)));
  },

  // ---- Quotations ----
  getQuotations() {
    return JSON.parse(localStorage.getItem('ka_quotations') || '[]');
  },
  addQuotation(q) {
    const list = this.getQuotations();
    q.id = this.uid();
    q.createdAt = new Date().toISOString();
    list.push(q);
    localStorage.setItem('ka_quotations', JSON.stringify(list));
    return q;
  },
  updateQuotation(id, data) {
    const list = this.getQuotations();
    const i = list.findIndex(x => x.id === id);
    if (i < 0) return null;
    list[i] = { ...list[i], ...data, updatedAt: new Date().toISOString() };
    localStorage.setItem('ka_quotations', JSON.stringify(list));
    return list[i];
  },
  deleteQuotation(id) {
    localStorage.setItem('ka_quotations', JSON.stringify(this.getQuotations().filter(q => q.id !== id)));
  },
  getQuotationById(id) {
    return this.getQuotations().find(q => q.id === id) || null;
  },

  // ---- Invoices ----
  getInvoices() {
    return JSON.parse(localStorage.getItem('ka_invoices') || '[]');
  },
  addInvoice(inv) {
    const list = this.getInvoices();
    inv.id = this.uid();
    inv.createdAt = new Date().toISOString();
    list.push(inv);
    localStorage.setItem('ka_invoices', JSON.stringify(list));
    return inv;
  },
  updateInvoice(id, data) {
    const list = this.getInvoices();
    const i = list.findIndex(x => x.id === id);
    if (i < 0) return null;
    list[i] = { ...list[i], ...data, updatedAt: new Date().toISOString() };
    localStorage.setItem('ka_invoices', JSON.stringify(list));
    return list[i];
  },
  deleteInvoice(id) {
    localStorage.setItem('ka_invoices', JSON.stringify(this.getInvoices().filter(inv => inv.id !== id)));
  },
  getInvoiceById(id) {
    return this.getInvoices().find(inv => inv.id === id) || null;
  },

  // ---- Repairs ----
  getRepairs() {
    return JSON.parse(localStorage.getItem('ka_repairs') || '[]');
  },
  addRepair(r) {
    const list = this.getRepairs();
    r.id = this.uid();
    r.createdAt = new Date().toISOString();
    list.push(r);
    localStorage.setItem('ka_repairs', JSON.stringify(list));
    return r;
  },
  updateRepair(id, data) {
    const list = this.getRepairs();
    const i = list.findIndex(x => x.id === id);
    if (i < 0) return null;
    list[i] = { ...list[i], ...data, updatedAt: new Date().toISOString() };
    localStorage.setItem('ka_repairs', JSON.stringify(list));
    return list[i];
  },
  deleteRepair(id) {
    localStorage.setItem('ka_repairs', JSON.stringify(this.getRepairs().filter(r => r.id !== id)));
  },
  getRepairById(id) {
    return this.getRepairs().find(r => r.id === id) || null;
  },

  // ---- Settings ----
  getSettings() {
    const defaults = {
      shopName: 'KitchenAid Service Center',
      address: '',
      phone: '',
      email: '',
      taxId: '',
      vatRate: 7,
      paymentInfo: '',
    };
    try {
      return { ...defaults, ...JSON.parse(localStorage.getItem('ka_settings') || '{}') };
    } catch (e) {
      return defaults;
    }
  },
  saveSettings(s) {
    localStorage.setItem('ka_settings', JSON.stringify(s));
  },
};
