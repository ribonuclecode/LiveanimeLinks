--バスター・モード
function c511002480.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c511002480.cost)
	e1:SetTarget(c511002480.target)
	e1:SetOperation(c511002480.activate)
	c:RegisterEffect(e1)
end
function c511002480.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c511002480.filter1(c,e,tp,ft)
	return c:IsType(TYPE_SYNCHRO) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) 
		and Duel.IsExistingMatchingCard(c511002480.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c511002480.filter2(c,tcode,e,tp)
	return c.assault_mode and c.assault_mode==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c511002480.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroup(tp,c511002480.filter1,1,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroup(tp,c511002480.filter1,1,1,nil,e,tp,ft)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c511002480.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.SelectMatchingCard(tp,c511002480.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,code,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c511002480.efilter)
		tc:RegisterEffect(e2,true)
		tc:CompleteProcedure()
	end
end
function c511002480.efilter(e,re,rp)
	return e:GetHandlerPlayer()~=rp
end