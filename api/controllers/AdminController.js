/**
 * Created by Uzo on 3/2/2017.
 */

module.exports = {
    dashboard: function(req, res) {
        if (!req.session.userId) {
            return res.view ('user/signin');
        }

        User.findOne(req.session.userId, function(err, user) {
            if (err) {
                return res.negotiate(err);
            }
            return res.view('admin/dashboard', {
                me: {
                    id: user.id,
                    fname: user.fullname,
                    email: user.email
                }
            });
        });
    },

    getNairaTransactions: function(req, res) {
        NairaTransaction.find().populate('user').sort({ createdAt: 'desc' }).exec(function(err, tnx) {
            if (err) {
                return res.negotiate(err);
            }
            return res.view('admin/naira-transactions', { trnx: tnx });
        });
    },

    getBTCTransactions: function(req, res) {
        BitcoinTransaction.find().sort({ createdAt: 'desc' }).exec(function(err, tnx) {
            if (err) {
                res.negotiate(err);
            }
            return res.view('admin/btc-transactions', { trnx: tnx });
        });
    },

    getUsers: function(req, res) {
        User.find().sort({ createdAt: 'desc' }).exec(function(err, users) {
            return res.view('admin/users', {'users': users});
        });
    },

    settings: function(req, res) {
        AdminBankAccount.find().exec(function(err, account) {
            UserLevel.find().sort({ level: 'asc'}).exec(function(err, levels) {
                if (err) return;
                return res.view('admin/settings', { 'account_details': account, 'levels': levels });
            });
        });
    },

    addBankAccount: function(req, res) {
        var data = {
            bank: req.param('bank'),
            account_name: req.param('account_name'),
            account_number: req.param('account_number')
        };

        AdminBankAccount.create(data).exec(function(err, account) {
            if (err) {
                return res.json(200, { status: 'error', msg: err });
            }
            return res.json(200, { status: 'success', id: account.id });
        });
    },
    
    getAccounts: function(req, res) {
        NairaAccount.adminAccountBalance().then(function(balance) {
            return res.view('admin/accounts', { balance: balance });
        });
    }
}
