//Meeflak
//Version 1.0
//Raise Max Capacity


// Raises the max capacity you can carry by doubling total carry capacity. 
// This gives you a litte more wiggle room when looting during missions/
// And removes the need to backtrack for more items if you want to 
// Return to loot

@replaceMethod(PlayerPuppet)
  public final func EvaluateEncumbrance() -> Void {
    let carryCapacity: Float;
    let hasEncumbranceEffect: Bool;
    let isApplyingRestricted: Bool;
    let overweightEffectID: TweakDBID;
    let ses: ref<StatusEffectSystem>;

    if this.m_curInventoryWeight < 0.00 {
      this.m_curInventoryWeight = 0.00;
    };

    ses = GameInstance.GetStatusEffectSystem(this.GetGame());
    overweightEffectID = t"BaseStatusEffect.Encumbered";
    hasEncumbranceEffect = ses.HasStatusEffect(this.GetEntityID(), overweightEffectID);
    isApplyingRestricted = StatusEffectSystem.ObjectHasStatusEffectWithTag(this, n"NoEncumbrance");
    carryCapacity = GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatType.CarryCapacity);
    carryCapacity = carryCapacity * 2.0; 

    if this.m_curInventoryWeight > carryCapacity && !isApplyingRestricted {
      this.SetWarningMessage(GetLocalizedText("UI-Notifications-Overburden"));
    };

    if this.m_curInventoryWeight > carryCapacity && !hasEncumbranceEffect && !isApplyingRestricted {
      ses.ApplyStatusEffect(this.GetEntityID(), overweightEffectID);
    } 
    else {
      if this.m_curInventoryWeight <= carryCapacity && hasEncumbranceEffect || hasEncumbranceEffect && isApplyingRestricted {
        ses.RemoveStatusEffect(this.GetEntityID(), overweightEffectID);
      };
    };
    
    GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_PlayerStats).SetFloat(GetAllBlackboardDefs().UI_PlayerStats.currentInventoryWeight, this.m_curInventoryWeight, true);
  }