const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const gmailEmail = defineSecret("GMAIL_EMAIL");
const gmailPassword = defineSecret("GMAIL_PASSWORD");

exports.sendEmailResponse = onRequest(
  { cors: true, secrets: ["GMAIL_EMAIL", "GMAIL_PASSWORD"] },
  async (req, res) => {
    if (req.method === "OPTIONS") {
      res.set("Access-Control-Allow-Methods", "POST");
      res.set("Access-Control-Allow-Headers", "Authorization, Content-Type");
      return res.status(204).send("");
    }

    // Check Firebase Authentication token
    if (!req.headers.authorization?.startsWith("Bearer ")) {
      res.status(403).json({ error: "Unauthorized: Missing Bearer token" });
      return;
    }

    const idToken = req.headers.authorization.split("Bearer ")[1];
    try {
      await admin.auth().verifyIdToken(idToken); // Validate token
    } catch (error) {
      res.status(403).json({ error: "Unauthorized: Invalid token" });
      return;
    }

    const { email, message } = req.body;
    if (!email || !message) {
      return res.status(400).json({ error: "Missing email or message" });
    }

    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: { user: gmailEmail.value(), pass: gmailPassword.value() },
    });

    try {
      await transporter.sendMail({
        from: `"Daiman Sri Skudai" <${gmailEmail}>`,
        to: email,
        subject: "Response to your report",
        html: `<p>${message.replace(/\n/g, "<br>")}</p>`,
      });
      res.status(200).json({ success: true });
    } catch (error) {
      logger.error("Email failed", error);
      res.status(500).json({ error: "Failed to send email" });
    }
  }
);
