'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const logging = require('@google-cloud/logging');
const stripe = require('stripe')(functions.config().stripe.secret, {
  apiVersion: '2020-03-02',
});
//check in on token-- Matt
const currency = functions.config().stripe.currency || 'USD';

// [START chargecustomer]
exports.createStripeCharge = functions.https.onCall(async (data, context) => {

            const amount = data.total;
            const idempotencyKey = data.idempotency;
            const customerId = data.customerId;
            const source = data.source;
            
            const charge = await stripe.charges.create({ 
              amount: amount, 
              currency: 'usd',
              customer: customerId,
              source: source,
          }, {
          idempotencyKey: idempotencyKey
        }); 
        return charge; 
});
// [END chargecustomer]]





exports.createChargeFunction = functions.https.onCall(async (data, context) => {
const amount = data.amount;
const paymentIntent = await stripe.paymentIntents.create({
  amount: amount,
  currency: 'usd',
  customer: 'cus_HX9HpktQ2oKuNs',
  transfer_data: {
    destination: 'acct_1GzaN0ErWenworok',
  },
});
const clientSecret = paymentIntent.client_secret
return clientSecret;
});

exports.getStripeEphemeralKeys = functions.https.onCall(async (data, context) => {
    const api_version = data.api_version;
    const customer_id = data.customer_id;
    const key = await stripe.ephemeralKeys.create(
        {customer: customer_id},
        {apiVersion: api_version}
    );
    return key;
});

exports.createStripeCustomer = functions.https.onCall(async (data, context) => {
    const full_name = data.full_name;
    const email = data.email;
    const customer = await stripe.customers.create({
        email: email,
        name: full_name,
        description: full_name
    });
    console.log('new customer created: ', customer.id)
    return {
        customer_id: customer.id
    }
});

exports.createCustomAccount = functions.https.onCall(async (data, context) => {
  const account = await stripe.accounts.create({
  country: 'US',
  type: 'custom',
  requested_capabilities: ['card_payments', 'transfers'],
});
  const id = account.id
   return id;
});


// Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
exports.addPaymentSource = functions.database
    .ref('/stripe_customers/{userId}/sources/{pushId}/token').onWrite((change, context) => {
      const source = change.after.val();
      if (source === null){
        return null;
      }
      return admin.database().ref(`/stripe_customers/${context.params.userId}/customer_id`)
          .once('value').then((snapshot) => {
            return snapshot.val();
          }).then((customer) => {
            return stripe.customers.createSource(customer, {source});
          }).then((response) => {
            return change.after.ref.parent.set(response);
          }, (error) => {
            return change.after.ref.parent.child('error').set(userFacingMessage(error));
          }).then(() => {
            return reportError(error, {user: context.params.userId});
          });
        });

// When a user deletes their account, clean up after them
exports.cleanupUser = functions.auth.user().onDelete((user) => {
  return admin.database().ref(`/stripe_customers/${user.uid}`).once('value').then(
      (snapshot) => {
        return snapshot.val();
      }).then((customer) => {
        return stripe.customers.del(customer.customer_id);
      }).then(() => {
        return admin.database().ref(`/stripe_customers/${user.uid}`).remove();
      });
    });

// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
// [START reporterror]
function reportError(err, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
  const log = logging.log(logName);

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  const metadata = {
    resource: {
      type: 'cloud_function',
      labels: {function_name: process.env.FUNCTION_NAME},
    },
  };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  const errorEvent = {
    message: err.stack,
    serviceContext: {
      service: process.env.FUNCTION_NAME,
      resourceType: 'cloud_function',
    },
    context: context,
  };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    log.write(log.entry(metadata, errorEvent), (error) => {
      if (error) {
       return reject(error);
      }
      return resolve();
    });
  });
}
// [END reporterror]

// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}