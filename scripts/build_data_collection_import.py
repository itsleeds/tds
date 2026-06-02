#!/usr/bin/env python3
"""Build a paste-ready Semester 2 import table for the Leeds Data Collection workbook.

This script reads data/timetable.csv and writes a CSV with columns matching the
"Data collection information" sheet (Semester 2 section, row 22 headers).

Design choice:
- We do NOT edit the Excel workbook directly, because direct writes from common
  libraries can strip validation/list features from this template.
- Instead we generate a values-only import table that can be pasted into rows
  23+ (Paste Special -> Values) in the workbook.
"""

from __future__ import annotations

import argparse
import csv
from collections import defaultdict
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import Dict, List

SEM2_WEEKS = list(range(14, 25))
WEEK_1_START = date(2026, 9, 28)
WEEK_LABELS = [
    *[str(i) for i in range(1, 12)],
    "C1",
    "C2",
    "C3",
    "C4",
    *[str(i) for i in range(12, 23)],
    "E1",
    "E2",
    "E3",
    "E4",
    *[str(i) for i in range(23, 31)],
]

OUTPUT_HEADERS = [
    "Activity Type",
    "Duration of Class",
    "No of Groups",
    "Max Group Size",
    "Room Type",
    "Special Equipment",
    "Lecture Capture",
    "Student Allocation",
    "Jointly Taught? ",
    "S2: Wk 14",
    "S2: Wk 15",
    "S2: Wk 16",
    "S2: Wk 17",
    "S2: Wk 18",
    "S2: Wk 19",
    "S2: Wk 20",
    "S2: Wk 21",
    "S2: Wk 22",
    "S2: Wk 23",
    "S2: Wk 24",
    "Notes",
]

ACTIVITY_DEFAULTS = {
    "LECTURE": {
        "Duration of Class": "1 hr",
        "No of Groups": 1,
        "Max Group Size": "",
        "Room Type": "Please select",
        "Special Equipment": "Please Select",
        "Lecture Capture": "Please select",
        "Student Allocation": "Random",
        "Jointly Taught? ": "No",
    },
    "PRACTICAL": {
        "Duration of Class": "2 hrs",
        "No of Groups": 1,
        "Max Group Size": "",
        "Room Type": "Please select",
        "Special Equipment": "Please Select",
        "Lecture Capture": "Please select",
        "Student Allocation": "Random",
        "Jointly Taught? ": "No",
    },
    "SEMINAR": {
        "Duration of Class": "3 hrs",
        "No of Groups": 1,
        "Max Group Size": "",
        "Room Type": "Please select",
        "Special Equipment": "Please Select",
        "Lecture Capture": "Please select",
        "Student Allocation": "Specific",
        "Jointly Taught? ": "No",
    },
}


def parse_activity(summary: str) -> str | None:
    s = summary.lower()
    if "deadline" in s:
        return None
    if "lecture" in s:
        return "LECTURE"
    if "practical" in s:
        return "PRACTICAL"
    if "seminar" in s:
        return "SEMINAR"
    return None


def parse_date(time_value: str) -> date:
    # Input format from timetable.csv is ISO-like, e.g. 2027-01-28T10:00:00Z
    return datetime.fromisoformat(time_value.replace("Z", "+00:00")).date()


def build_week_lookup() -> Dict[date, str]:
    lookup: Dict[date, str] = {}
    for idx, label in enumerate(WEEK_LABELS):
        wk_start = WEEK_1_START + timedelta(days=7 * idx)
        lookup[wk_start] = label
    return lookup


def term_week_label(d: date, week_lookup: Dict[date, str]) -> str | None:
    # Events happen on specific weekdays, so map by Monday week commencing date.
    wk_start = d - timedelta(days=d.weekday())
    return week_lookup.get(wk_start)


def build_rows(input_csv: Path) -> List[Dict[str, object]]:
    weeks_by_activity: Dict[str, set[int]] = defaultdict(set)
    locations_by_activity: Dict[str, set[str]] = defaultdict(set)
    week_lookup = build_week_lookup()

    with input_csv.open("r", newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            summary = (row.get("summary") or "").strip()
            activity = parse_activity(summary)
            if activity is None:
                continue

            event_date = parse_date((row.get("time") or "").strip())
            wk_label = term_week_label(event_date, week_lookup)
            if wk_label is None or not wk_label.isdigit():
                continue

            wk = int(wk_label)
            if wk not in SEM2_WEEKS:
                continue

            weeks_by_activity[activity].add(wk)
            location = (row.get("location") or "").strip()
            if location:
                locations_by_activity[activity].add(location)

    ordered_activities = ["LECTURE", "PRACTICAL", "SEMINAR"]
    out_rows: List[Dict[str, object]] = []

    for activity in ordered_activities:
        if activity not in weeks_by_activity:
            continue

        row: Dict[str, object] = {h: "" for h in OUTPUT_HEADERS}
        row["Activity Type"] = activity

        for key, value in ACTIVITY_DEFAULTS[activity].items():
            row[key] = value

        for wk in SEM2_WEEKS:
            row[f"S2: Wk {wk}"] = "Y" if wk in weeks_by_activity[activity] else ""

        locations = sorted(locations_by_activity.get(activity, set()))
        if locations:
            row["Notes"] = "Locations: " + "; ".join(locations)

        out_rows.append(row)

    return out_rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input",
        default="data/timetable.csv",
        help="Path to timetable CSV (default: data/timetable.csv)",
    )
    parser.add_argument(
        "--output",
        default="data/data-collection-sem2-import.csv",
        help="Path to output import CSV",
    )
    args = parser.parse_args()

    input_csv = Path(args.input)
    output_csv = Path(args.output)

    rows = build_rows(input_csv)
    output_csv.parent.mkdir(parents=True, exist_ok=True)
    with output_csv.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=OUTPUT_HEADERS)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Wrote {len(rows)} rows to {output_csv}")


if __name__ == "__main__":
    main()
