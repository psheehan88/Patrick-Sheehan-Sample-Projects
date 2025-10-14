import express, { Request, Response } from "express";

const app = express();
const PORT = process.env.PORT || 3000;

interface DiscountCode {
	code: string;
	expiration: Date;
	discountPercent: number;
}

const discountCodes: DiscountCode[] = [
	{ code: "WELCOME10", expiration: new Date("2025-12-31"), discountPercent: 10 },
	{ code: "SUMMER25", expiration: new Date("2025-08-01"), discountPercent: 25 },
	{ code: "BLACKFRIDAY50", expiration: new Date("2025-11-29"), discountPercent: 50 }
];

app.get("/api/validate/:code", (req: Request, res: Response) => {
	const { code } = req.params;
	const match = discountCodes.find(c => c.code.toUpperCase() === code.toUpperCase());

	if (!match) {
		return res.status(404).json({ valid: false, reason: "Code not found" });
	}

	const now = new Date();
	if (match.expiration < now) {
		return res.json({ valid: false, reason: "Code expired" });
	}

	res.json({
		valid: true,
		code: match.code,
		discount: `${match.discountPercent}% off`,
		expires: match.expiration.toISOString().split("T")[0]
	});
});

app.listen(PORT, () => {
	console.log(`✅ Discount API running on http://localhost:${PORT}`);
});
