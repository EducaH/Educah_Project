class Branche {
  final int? brancheId;
  final String? brancheCategory;
  final String? brancheName;
  final String? brancheDescription;

  Branche(
      {this.brancheId,
      this.brancheCategory,
      this.brancheName,
      this.brancheDescription});

  factory Branche.fromFirestore(Map<String, dynamic> snapshot) {
    return Branche(
        brancheId: snapshot['brancheId'],
        brancheCategory: snapshot['brancheCategory'],
        brancheName: snapshot['brancheName'],
        brancheDescription: snapshot['brancheDescription']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (brancheId != null) 'brancheId': brancheId,
      if (brancheCategory != null) 'brancheCategory': brancheCategory,
      if (brancheName != null) 'brancheName': brancheName,
      if (brancheDescription != null) 'brancheDescription': brancheDescription
    };
  }
}
