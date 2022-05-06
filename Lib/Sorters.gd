class_name Sorters


static func artifacts_by_name(a: Artifact, b: Artifact) -> bool:
	if a.name.naturalnocasecmp_to(b.name) == -1:
		return true
	return false
